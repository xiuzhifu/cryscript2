--[[ bnf
  block -> statement
  statement -> assign-stmt| callfun-stmt
  assign-stmt -> object-stmt{, object-stmt}  = exp {, exp}
  exp-> term1 logicop term1|term1
  term1-> term asop term|term
  term -> factor mdop factor|factor
  factor-> (exp)|num|identifier|string|callfun-stmt
  asop-> +|-
  mdop-> *|/|%
  num->0..9
  logicop-> <|>|=|>=|<=
  string->"xxoo"
  func-stmt ->  function ({statement})   end
  return-stmt -> return exp
  callfunc-stmt -> object-stmt({statement})|  object-stmt {statement} | object-stmt({statement}) {block}
  object-stmt -> Object functionname| Object.functionname|functionname(Object)| Object
]]

local OperatorTable = require "OperatorTable"

local lex = require "lex"
local emitter = require "emitter"
local m = {}

function m.error(e)
	print('line: '..tostring(lex.line)..' error: '..e)
end

function m.parser(source)
  lex.load(source)
  while true do
    local token = lex.getnexttoken() 
    if token == tkend then break end
    m.statement()
  end
  print("parser ended")
end

--statement -> assign-stmt| callfun-stmt | return-stmt
function m.statement()
	local token = lex.getnexttoken()
	if token == tkclass then
		m.callfunction_statement(tkclass)
	elseif token == tkassign then
		m.assign_statement()
	elseif token == tkident then
		m.callfunction_statement(tkident)
	elseif token == tknumber then
		m.exp_statement()
	else
		m.error('statement() unknown token: '..token)
	end
end

--object-stmt ->Object functionname [functionname]|Object.functionname[.functionname]|functionname(Object)| Object
function m.object_statement(token)
  lex.match(token)
  local classname = lex.gettokenstring()
  local l = lex.line
  local token, c = lex.getnexttoken()
  local classfunction = {}
  --like O = Object or O = Object new or O = Object.new or O = new(Object)lex.match(tkassign)
	if token == tkdot then	--O = Object.new
		while token == tkdot do
			lex.match(tkdot)
			lex.match(tkident)
			table.instert(classfunction, lex.gettokenstring())
			token = lex.getnexttoken()
		end
		return emitter.emit_object(classname, classfunction)
	elseif token == tkident then 	--O = Object new
		while l == c and token == tkident do
			lex.match(tkident)
			table.insert(classfunction, lex.gettokenstring())
      l = lex.line
			token, c = lex.getnexttoken()
		end
		return emitter.emit_object(classname, classfunction)
	else--O = Object
		return emitter.emit_object(classname)
	end
end

function m.block_statement()

end

function m.number()
  lex.match(tknumber)
  return tknumber, lex.gettokenstring()
end

function m.string()
  lex.match(tkstring)
  return tkstring, lex.gettokenstring()
end

-- assign-stmt -> object-stmt{, object-stmt}  = sexp {, sexp}
function m.assign_statement()
	lex.match(tkassign)
	m.exp_statement()
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

-- func-stmt ->  function ({statement})   end
function m.function_statement()
end

-- callfunc-stmt -> object-stmt({callfunction_statement})|  
--object-stmt {callfunction_statement} | object-stmt({callfunction_statement}) {block}
function m.callfunction_statement(token)
	m.object_statement(token)
	local token = lex.getnexttoken()
	if token == tkleftbracket then
		lex.match(tkleftbracket)
		local r = m.exp_statement()
		lex.match(tkrightbracket)
		emitter.emit_callfunction(s, r)
	end
	if token == tkleftbrace then
		lex.match(tkleftbrace)
		m.block_statement()
		lex.match(tkrightbrace)
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
m.parser("O = Object new ")
local vm =  require 'vm'
vm.execute()

