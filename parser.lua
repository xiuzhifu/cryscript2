--[[ bnf
  block -> statement
  statement -> assign-stmt| callfun-stmt
  assign-stmt -> object-stmt{, object-stmt}  = sexp {, sexp}
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
local tkfunction = 'tkfunction'

local Object = require "object"
local Number = require "number"
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
  end
end

--statement -> assign-stmt| callfun-stmt | return-stmt
function m.statement()
	local token = lex.getnexttoken()
	if token == tkclass then
		m.callfunction_statement(tkclass)
	elseif token = tkassign then
		m.assign_statement()
	elseif token == tkident then
		m.callfunction_statement(tkident)
	else
		m.error('statement() unknown token: '..token)
end

local function function_statement( ... )

end

--object-stmt ->Object functionname [functionname]|Object.functionname[.functionname]|functionname(Object)| Object
local function m.object_statement(token)
  lex.match(token)
  local classname = lex.gettokenstring()
  local token = lex.getnexttoken()
  local classfunction = {}
  --like O = Object or O = Object new or O = Object.new or O = new(Object)lex.match(tkassign)
	if token == tkdot then	--O = Object.new
		while token == tkdot do
			lex.match(tkdot)
			lex.match(tkident)
			table.instert(classfunction, lex.gettokenstring())
			token = lex.getnexttoken()
		end
		emitter.emit_object(classname, classfunction)
	elseif token == tkident then 	--O = Object new
		while token == tkident do
			lex.match(tkident)
			table.instert(classfunction, lex.gettokenstring())
			token = lex.getnexttoken()
		end
		emitter.emit_object(classname, classfunction)
	else--O = Object
		emitter.emit_object(classname)
	end
	else
		m.error('object_statement() :'..token)
	end																		
end

function m.block_statement()

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
	lex.match(tkassign)
	m.exp_statement()
end

-- exp = callfunc-stmt|object-stmt
function m.exp_statement()
  -- body
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
function m.gen_operator_parser()
  local otleveltable = {}
  function gen_operator_level()
    local otlen = #OperatorTable
    local ii = 1
    for i,v in pairs(OperatorTable) do
      otleveltable[ii] = i
      ii = ii + 1 
    end
  end
  gen_operator_level()
end
m.gen_operator_parser()
