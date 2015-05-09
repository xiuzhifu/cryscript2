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

function m.error(e)
	print('line: '..tostring(lex.line)..' error: '..e)
end

function m.parser(source)
	lex.load(source)
	local n
	while true do
		local token = lex.getnexttoken()
		if token == tkend then break end
		n = m.statement(n)
	end
	print("parser ended")
	emitter.insts = emitter.insts .. [[
end
main()
]]
	print(emitter.insts)
	--local f = io.open('main.lua', 'w')
	--f:write(emitter.insts)
	--io.close(f)
	--loadfile('main.lua')()
end

--statement -> callfun-stmt | return-stmt
function m.statement(n)
	while true do
    local token = lex.getnexttoken()
    if token == tkend then break end
		if token == tkclass or token == tkident or token == tkstring or token == tknumber then
			local r = m.object_statement(1)
		else
			m.error('statement() unknown token: '..token)
      break
		end
	end
end
--object-stmt ->Object functionname [functionname]|Object.functionname[.functionname]|functionname(Object)| Object
function m.object_statement(layer, object, token)
	local left, right, operator, tk1, tk2, tk3, c, l 
	tk1, c, l = lex.getnexttoken()
	if c ~= l then return object end
	lex.match(tk1)
	left = lex.gettokenstring()--object
	if tk1 == tkassign then
		
		right = m.object_statement(layer + 1)
		emitter.emit_assign(layer, object, right, token)
		return
	end
	if not object then
			tk2, c, l = lex.getnexttoken()--operator
			if tk2 == tkassign then 	
				return m.object_statement(layer + 1, left, tk1)
			end
			if c == l then 
				lex.match(tk2)
				operator = lex.gettokenstring()					
			end
	else
		tk1 = tkclass
		operator = left
		left = object
	end
	object = emitter.emit(operator, layer, {tk1, left})
	if c ~= l then return object end
	tk3, c, l = lex.getnexttoken()
	if l == c then
		if tk3 == tkident then 
			m.object_statement(layer + 1, object, tk3)
		elseif tk3 == tkstring or tk3 == tknumber then
			left = lex.gettokenstring()
			object = emitter.emit(operator, layer, {tk3, left})
			m.object_statement(layer + 1, object, tk3)
		else
			m.object_statement(layer + 1, object, tk3)
		end
	end
	return object
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

