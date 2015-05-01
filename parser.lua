--[[ bnf
  block -> statement
  statement -> assign-stmt| callfun-stmt | return-stmt
  assign-stmt -> object-stmt{, object-stmt}  = sexp {, sexp}
  exp = identifiers|callfunc-stmt|object-stmt
  logicexp -> exp logicop exp
  logicop-> <|>|=|>=|<=
  exp-> term asop term|term
  term -> factor mdop factor|factor
  factor-> (exp)|num|identifier|string|callfun-stmt
  asop-> +|-
  mdop-> *|/|%
  num->0..9
  identifier-> _identifiernum|a..zidentifiernum|A..Zidentifiernum
  func-stmt ->  function ({statement})   end
  return-stmt -> return sexp
  callfunc-stmt -> object-stmt({statement})|  object-stmt {statement} | object-stmt({statement}) {block}
  object-stmt -> Object functionname| Object.functionname|functionname(Object)| Object
]]

local tkend = 'tkend'
local tkident = 'tkident'
local tknumber = 'tknumber'
local tkfloat = 'tkfloat'
local tkstring = 'tkstring'
local tkoperator = 'tkoperator'
local tkleftbracket = 'tkleftbracket' --(
local tkrightbracket = 'tkrightbracket'--)
local tkleftsquarebracket = 'tkleftsquarebracket' --[
local tkrightsquarebracket = 'tkrightsquarebracket' --]
local tkleftbrace = 'tkleftbrace'--{
local tkrightbrace = 'tkrightbrace'--}
local tkdot = 'tkdot'
local tkand = 'tkand'
local tkor = 'tkor'
local tknot = 'tknot'
local tkmod = 'tkmod'
local tkdiv = 'tkdiv'
local tkmul = 'tkmul'
local tkadd = 'tkadd'
local tksub = 'tksub'
local tkeq = 'tkeq'
local tkless = 'tkless'
local tklesseq = 'tklesseq'
local tkbig = 'tkbig'
local tkbigeq = 'tkbigeq'
local tkuneq = 'tkuneq'
local tkassign = 'tkassign'
local tkcomma ='tkcomma'
local tkclass = 'tkclass'

local Object = require "object"
local Number = require "number"

local lex = require "lex"
local emitter = require "emitter"
local m = {}

local operatortable = {}
operatortable[2] = {
  [tkmod] = operator_mod,
  [tkmul] = operator_mul,
  [tkdiv] = operator_div
}

operatortable[3] = {
  [tkadd] = operator_add, 
  [tksub] = operator_sub
}

operatortable[5] = {
  [tkless] = operator_less, 
  [tklesseq] = operator_lesseq,
  [tkbig] = operator_big,
  [tkbigeq] = operator_bigeq,
}

operatortable[6] = {
  [tkuneq] = operator_uneq,
  [tkeq] = operator_eq
}

operatortable[7] = {
  [tkor] = operator_or
}

operatortable[8] = {
  [tkand] = operator_and
}

local function operator_add()
end

local function operator_sub()
end

local function operator_mul()
end

local function operator_div()
end

local function operator_mod()
end

local function operator_less()
end

local function operator_lesseq()
end

local function operator_big()

end

local function operator_bigeq()

end

local function operator_noteq()

end

local function operator_eq()

end

local function operator_or()

end

local function operator_and()

end

function m.error(e)
	print('line: '..tostring(lex.line)..' error: '..e)

function m.parser(source)
  lex.load(source)
  while true do
    local token = lex.getnexttoken() 
    if token == tkend then break end
    if m[token] then
      m[token]() 
    else
      m.error('parser() unknown token: '..token)
    end
  end
end

--object-stmt ->Object.functionname|functionname(Object)| Object
function object_statement()
  lex.match(tkclass)
	local classname = lex.gettokenstring()
  local token = lex.getnexttoken()
	local copyclassname
  if token == tkdot then 
    lex.match(tkdot)
    token = lex.getnexttoken()
  end
  if token == tkassign then--like O = Object or O = Object.new or O = new(Object)
		lex.match(tkassign)
		token = lex.getnexttoken()
		if token == tkclass then
			lex.match(tkclass)
			copyclassname = lex.gettokenstring()
			token = lex.getnexttoken()
			if token == tkdot then	--O = Object.new
				lex.match(tkdot)
				lex.match(tkident)
				copyclassfunction = lex.gettokenstring()
				emitter.emit_object(classname, copyclassname, copyclassfunction)
			else	--O = Object
				emit_object.emit_object(classname, copyclassname)
			end
		elseif token == tkident then
			copyclassfunction = lex.getcurrentstring
		else
			m.error('object_statement() :'..token)
		end
			
	else-- O = new(Object)
			token = lex.getnexttoken()
	end
  elseif token == tkident then
  end
end
m[tkclass] = object_statement

function m.gen_operator_parser()
  local otleveltable = {}
  function gen_operator_level()
    local otlen = #operatortable
    local ii = 1
    for i,v in pairs(operatortable) do
      otleveltable[ii] = i
      ii = ii + 1 
    end
  end
  gen_operator_level()
end

function m.identifier()
  lex.match(tkident)
  return lex.gettokenstring()
end

function m.number()
  lex.match(tknumber)
  return lex.gettokenstring()
end

function m.string()
  lex.match(tkstring)
  return lex.gettokenstring()
end

--factor-> (exp)|num|identifier|string|callfun-stmt
function m.factor_statement()
  local token = lex.getnexttoken()
  if token == tknumber then
  if token == tkclass then
  elseif token == tkstring then
  elseif token == tkident then
  elseif token == tkleftbracket then
  end 
end

-- assign-stmt -> object-stmt{, object-stmt}  = sexp {, sexp}
function m.assign_statement()
  -- body
end

-- exp = identifiers|callfunc-stmt|object-stmt
function m.exp_statement()
  -- body
end

-- func-stmt ->  function ({statement})   end
function m.function_statement()
end

-- callfunc-stmt -> object-stmt({statement})|  object-stmt {statement} | object-stmt({statement}) {block}
function m.callfunction_statement()
end

function m.statement()
end

m.gen_operator_parser()
