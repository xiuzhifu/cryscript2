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
local tkoperator = {'%', '*', '/', '+', '-', '<', '<=', '>', '>=', '!=', '==', 'or', 'and'}
local operatortable = {}
operatortable[2] = {
	['%'] = operator_mod,
	['*'] = operator_mul,
	['/'] = operator_div
}

operatortable[3] = {
	['+'] = operator_add, 
	['-'] = operator_sub
}

operatortable[5] = {
	['<'] = operator_less, 
	['<='] = operator_lesseq,
	['>'] = operator_big,
	['>='] = operator_bigeq
}

operatortable[6] = {
	['!='] = operator_noteq,
	['=='] = operator_eq
}

operatortable[7] = {
	['or'] = operator_or
}

operatortable[8] = {
	['and'] = operator_and
}

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
