--[[ bnf
block -> statement
statement -> assign-stmt| callfun-stmt |new-stmt
new-stmt-> object-stmt := exp 因为函数调用允许没有括号，所以，要分清是调用还是取地址，要多加一个操作符
exp-> term1 logicop term1|term1
term1-> term asop term|term
term -> factor mdop factor|factor
factor-> (exp)|num|identifier|string|callfun-stmt
asddop-> +|-
mdop-> *|/|%
num->0..9
logicop-> <|>|=|>=|<=
string->"xxoo"
func-stmt ->  function ({statement})   end
return-stmt -> return exp
callfunc-stmt -> object-stmt({statement})|  object-stmt {statement} | object-stmt({statement}) {block}
object-stmt -> Object functionname| Object.functionname|functionname(Object)| Object
]]

--什么运算符没有运算符，只有定义在OpereatorTable里面的优先级，如果在OT中有定义，需要parser完整个语句才生成操作，
--不然的化直接生成操作

local OperatorTable = require "OperatorTable"

local lex = require "lex"
local emitter = require "emitter"
local m = {}
local symboltable = {}
m.chunk = {}
function m.error(e)
	print('line: '..tostring(lex.line)..' error: '..e)
end

function m.load(filename)
  local f = io.open(filename, 'r')
  local s =  f:read('a')
  io.close(f)
  s == 'object '..filename..' < Object\n'..s .. 'end'
  local c = {
          ['source'] = s,
          ['name'] = filename,
  }
  local l = #m.chunk
  m.chunk[l] = c
  m.parser(l)
end

function m.parser(index)
  m.currentchunk = m.chunk[index]
	lex.load(m.currentchunk['source'])
	while true do
		m.statement()
	end
	print("parser ended")
end
--statement -> callfun-stmt | return-stmt
function m.statement(owner)
	while true do
    local token = lex.getnexttoken()
    if token == tkfinal then break end
		if token == tkobject then
			local r = m.object_statement(owner)
    elseif token == tkident then
    end
		else
			m.error('statement() unknown token: '..token)
      break
		end
	end
end

function m.statement_statement()
end

function m.function_statement(layer, objectname)
  lex.match(tkfunction)
  local functionname
  lex.match(tkident)
  functionname = lex.gettokenstring()
  m.emit_function(objectname, funcitonname)
  while true do--parser param
    local tk1, c1, l1 = lex.getnexttoken()
    if c1 ~= l1 then break end
    lex.match(tkident)
    emitter.emit_function_param(objectname, funcitonname, lex.gettokenstring())
  end
  while true do
    local tk2 , c2, l2 = lex.getnexttoken()
    if tk2 == tkend then break end
    m.call_statement(objectname, functionname)
  end
  lex.match(tkend)
end

function m.lambda_statement(layer, objectname)
end

function m.assign_statement(layer)
end

function m.call_statement(objectname, functionname)
  local left, name, token, c, l, variablename
  lex.match(tkident)
  left = lex.gettokenstring()
  token = lex.getnexttoken()
  while true do
  name, c, l = lex.gettokenstring()
  if c ~= l then break end
  if token == tkassign then
    right = m.assign_statement(objectname)
    emitter.emit_object_variable(objectname, left, right)
    break
  elseif emitter.isvariable(name) then
    variablename = name
    lex.match(tkident)
  elseif emitter.isfunction(name) then
    emitter.emit_command(objectname, functionname, 'call', )
  else--if is not variable or function ,then is a note
    lex.match(tkident)
  end
end
   
end

function m.object_statement(owner)
	local objectname, left, right, operator, tk1, tk2, tk3, c, l
	lex.match(tkobject)
  lex.match(tkident)
  objectname = lex.gettokenstring()
  lex.match(tkless)
  lex.match(tkident)
  copyobjectname = lex.gettokenstring()
  emitter.emit_object(objectname, copyobjectname, owner)
	local token = lex.getnexttoken()
  while token ~= tkend do
    if token == tkobject then
      m.object_statement(owner..'.'..objectname)
    elseif token == tkfunction then
      m.function_statement(layer, objectname)
    elseif token == tkident then
      m.call_statement(objectname, 'init')
    else
      m.error('object_statement()')
    end
    token = lex.getnexttoken()
  end
  lex.match(tkend)
  emitter.emit_object_end(objectname)
end
end

function m.number()
	lex.match(tknumber)
	return tknumber, lex.gettokenstring()
end

function m.string()
	lex.match(tkstring)
	return tkstring, lex.gettokenstring()
end

function m.exp_statement()
	local tk, s = m.term_statement()
	print(tk, s)
	local c = lex.line
	local token, l = lex.getnexttoken()
	print(c, l)
	if c == l and token == tkident then
		lex.match(token)
		emitter.emit_callfunction(tk, s, lex.gettokenstring())
	end
end

--factor-> (exp)|num|identifier|string|callfun-stmt
function m.factor_statement()
	local token = lex.getnexttoken()
	if token == tknumber then
		return m.number()
	elseif token == tkclass then
		return m.callfunction_statement(tkclass)
	elseif token == tkstring then
		return m.string()
	elseif token == tkident then
		return m.callfunction_statement(tkident)
	elseif token == tkleftbracket then
	end
end

local otleveltable = {}
local otlen = #OperatorTable
local terms = {}
local operators = {}
--term-> term1 asop(+-) term1|term1
--term1 -> factor mdop(*/) factor|factor
function m.gen_operator_parser()
	function gen_operator_level()
		local ii = 1
		for i,v in pairs(OperatorTable) do
			otleveltable[ii] = i
			ii = ii + 1
		end
	end
	
	function gen_term_statement(i)
		return function()
			local tk1, s1 = terms[i + 1]()
			while true do
				local token = lex.getnexttoken()
				local b, op = OperatorTable.isinthislevel(token, otleveltable[i])
				if b then
					lex.match(token)
					local tk2, s2 = terms[i + 1]()
					print(token, tk1, s1, tk2, s2)
					tk1, s1 = emitter.emit_exp(op, tk1, s1, tk2, s2)
				else
					break
				end
			end
			return tk1, s1
		end
	end
	gen_operator_level()
	for i=1,otlen do
		terms[i] = gen_term_statement(i)
	end
	m.term_statement = terms[1]
	terms[otlen + 1] = m.factor_statement
end
m.gen_operator_parser()
local f = io.open('test.cry', 'r')
local s =  f:read('a')
io.close(f)
m.parser(s)

