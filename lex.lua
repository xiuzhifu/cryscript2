--[[ bnf
  program -> stmt-sequence
  stmt-sequence -> stmt-sequence;statement|statement
  statement -> for-stmt|if-stmt| while- stmt| assign-stmt| read-stmt| write-stmt | funcstmt | var-stmt| return-stmt
  if-stmt -> if logicexp then stmt-sequence end | if exp then stmt-sequence else stmt-sequence end
  while-stmt-> while logicexp do stmt-sequence end
  assign-stmt -> identifiers = sexp|identifiers|callfunc-stmt|object-stmt
  read-stmt-> read identifier
  write- stmt -> write logicexp
  logicexp -> sexp logicop sexp
  logicop-> <|>|=|>=|<=
  sexp-> term asop term|term
  term -> factor mdop factor|factor|callfun-stmt|funcstmt|
  factor-> (exp)|num|identifier|string
  asop-> +|-
  mdop-> *|/|%
  num->0..9
  identifier-> _identifiernum|a..zidentifiernum|A..Zidentifiernum
  identifiers-> identifier| identifier,stmt_assign
  funcstmt ->  function (identifiers | nil ) begin  stmt-sequence | nil end
  var-stmt -> var assign-stmt
  return-stmt -> return sexp
  callfunc-stmt -> (identifiers | nil)
]]

local m ={}

local function isoperator(w)
	local operator = {'%', '*', '/', '+', '-', '<', '<=', '>', '>=', '!=', '==', 'or', 'and'}
	for _, v in pairs(operator) do
		if w == v then return true end
	end
	return false
end

local function islower(w)
	local words = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
	for _, v in pairs(words) do
		if w == v then return true end 
	end
	return false
end

local function isupper(w)
	local words = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','I','V','W','X','Y','Z'}
	for _, v in pairs(words) do
		if w == v then return true end 
	end
	return false
end

local function isalpha(w)
	return islower(w) or isupper(w)
end

local function isdigit(w)
	local words = {'0','1','2','3','4','5','6','7','8','9'}
	for _, v in pairs(words) do
		if w == v then return true end
	end
	return false
end

local function isalnum(w)
	return isalpha() or isdigit()

local function isseparator(w)
	if w == '\'' or w == '\n' then return true else return false end 
end

local function isblankspace(w)
	if w == ' ' then return true else return false end
end

m.line = 1
m.source = ''
m.current = 1

m.tokenstring = ''
--定义一系列常量，方便使用
local tkend = 'tkend'
local tkident = 'tkident'
local tknumber = 'tknumber'
local tkfloat = 'tkfloat'
local tkstring = 'tkstring'
local tkoperator = 'tkoperator'

function m.getnexttokenstring()
end

function m.getcurrentstring()
end

function m.error(e)
	print('line:'..tostring(m.line)..', error: '..e)
end

function m.incline()
	m.line = m.line + 1
end

function m.lex(source)
	m.source = source..' ' -- add a space to easily using isend function
	m.length = string.len(source)
end

function m.skipblankspace()
	local w = string.sub(m.source, m.current, m.current)
	if w == ' ' and m.next() then 
		m.skipblankspace()
	end 
end

	function m.match(token)
end

function m.next()
	m.current = m.current + 1
	return not m.isend()
end

function m.isend()
	if m.current > m.length then return true else return false end
end

local function lex_number()
	function lex_number_sub()
		local w = string.sub(m.source, m.current, m.current)
		if isblankspace(w) then
			return ''
		elseif isdigit(w) and m.next() then
			return w .. lex_number()
		else
			m.error('error number: '..m.tokenstring..w)
		end
	end
	return string.sub(lex_number_sub(), 1, -2)
end

m[tknumber] = lex_number

local function lex_string()

function m.getnexttoken()
	if m.isend() then return tkend end
	m.skipblankspace()
	local state
	local w = string.sub(m.source, m.current, m.current)
	if w == '\'' or w == '\"' then
		state = tkstring
	elseif isdigit(w) then
		state = tknumber
	elseif isalpha(w) then
		state = tkident
	elseif isoperator(w) then
		state = tkoperator
	end
	print(state, m[tknumber])
	m.tokenstring = m[state]()
	return state
end
m.source = '12345 '
m.length = 6
m.getnexttoken()
m.tokenstring = m.tokenstring..'!'
print(m.tokenstring)


