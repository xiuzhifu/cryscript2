--[[ bnf
  program -> stmt-sequence
  stmt-sequence -> stmt-sequence;statement|statement
  statement -> for-stmt|if-stmt| while- stmt| assign-stmt| read-stmt| write-stmt | func-stmt | var-stmt| return-stmt
  if-stmt -> if logicexp then stmt-sequence end | if exp then stmt-sequence else stmt-sequence end
  while-stmt-> while logicexp do stmt-sequence end
  assign-stmt -> identifiers = sexp|identifiers|callfunc-stmt|object-stmt
  read-stmt-> read identifier
  write- stmt -> write logicexp
  logicexp -> sexp logicop sexp
  logicop-> <|>|=|>=|<=
  sexp-> term asop term|term
  term -> factor mdop factor|factor|callfun-stmt|func-stmt|
  factor-> (exp)|num|identifier|string
  asop-> +|-
  mdop-> *|/|%
  num->0..9
  identifier-> _identifiernum|a..zidentifiernum|A..Zidentifiernum
  identifiers-> identifier| identifier,stmt_assign
  func-stmt ->  function (identifiers | nil ) begin  stmt-sequence | nil end
  var-stmt -> var assign-stmt
  return-stmt -> return sexp
  callfunc-stmt -> (identifiers | nil)
]]

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
local tkassign = 'tkassign'

local lex = require "lex"
local m = {}

function m.parser(source)
  lex.load(source)
  
end


function operator_add()
end

function operator_sub()
end

function operator_mul()
end

function operator_div()
end

function operator_mod()
end

function operator_less()
end

function operator_lesseq()
end

function operator_big()

end

function operator_bigeq()

end

function operator_noteq()

end

function operator_eq()

end

function operator_or()

end

function operator_and()

end
