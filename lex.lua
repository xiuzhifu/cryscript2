local precomplier = require 'precomplier'
local m ={}

m.line = 1
m.source = ''
m.current = 1

m.tokenstring = ''
--define series globle string for easily using 
tkend = 'tkend'
tkident = 'tkident'
tknumber = 'tknumber'
tkfloat = 'tkfloat'
tkstring = 'tkstring'
tkoperator = 'tkoperator'
tkleftbracket = 'tkleftbracket' --(
tkrightbracket = 'tkrightbracket'--)
tkleftsquarebracket = 'tkleftsquarebracket' --[
tkrightsquarebracket = 'tkrightsquarebracket' --]
tkleftbrace = 'tkleftbrace'--{
tkrightbrace = 'tkrightbrace'--}
tkdot = 'tkdot'
tkand = 'tkand'
tkor = 'tkor'
tknot = 'tknot'
tkmod = 'tkmod'
tkdiv = 'tkdiv'
tkmul = 'tkmul'
tkadd = 'tkadd'
tksub = 'tksub'
tkeq = 'tkeq'
tkless = 'tkless'
tklesseq = 'tklesseq'
tkbig = 'tkbig'
tkbigeq = 'tkbigeq'
tkuneq = 'tkuneq'
tkassign = 'tkassign'
tkcomma ='tkcomma'
tkclass = 'tkclass'
tkfunction = 'tkfunction'
tkobject = 'tkobject'
tknode = "tknode"
tkcolon = 'tkcolon'
tknew = 'tknew'

m[tkand] = 'and'
m[tkor] = 'or'
m[tknot] = 'not'
m[tkfunction] = 'function'

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
	return isalpha(w) or isdigit(w)
end

local function isblankspace(w)
	if w == ' ' or w == '\n' then return true else return false end
end

function m.gettokenstring()
	return m.tokenstring
end

function m.error(e)
	print('line:'..tostring(m.line)..', error: '..e)
end

function m.incline()
	m.line = m.line + 1
end

function m.load(source)
	source = precomplier.load(source)
	m.source = source..'   ' -- add a space for easily using isend function
	m.length = string.len(source)
end

function m.skipblankspace()
	local w = string.sub(m.source, m.current, m.current)
	if (w == ' ' or w == '\n' or w == '\r' or w == ';') and m.next() then
		m.skipblankspace()
		if w == '\n' then m.incline() end
	end 
end

function m.next()
	m.current = m.current + 1
	--return not m.isend()
	return true
end

function m.isend()
	if m.current > m.length then return true else return false end
end

local function lex_number()
	function lex_number_sub()
		local w = string.sub(m.source, m.current, m.current)
		if isblankspace(w) or m.isaoperator(w) then
			return ''
		elseif isdigit(w) and m.next() then
			return w .. lex_number_sub()
		else
			m.error('number: '..w)
		end
	end
	--return string.sub(lex_number_sub(), 1, -1)
	return lex_number_sub()
end
m[tknumber] = lex_number

local function lex_string()
	function lex_string_sub(b)
		local w = string.sub(m.source, m.current, m.current)
		if w == b then
			return ''
		elseif m.next() then
			return w .. lex_string_sub(b)
		else
			m.error('string: '..m.tokenstring..w)
		end
	end
	local w = string.sub(m.source, m.current, m.current)
	if w == '"' or w == "'" then
		m.next()
		local s = lex_string_sub(w)
		m.next()
		return s
	end 
end
m[tkstring] = lex_string

local function lex_ident()
	local w = string.sub(m.source, m.current, m.current)
	if isblankspace(w) then
		return ''
	elseif m.next() then
		return w .. lex_ident()
	else
		m.error('ident: '..m.tokenstring..w)
	end
end
m[tkident] = lex_ident

local simpletokentable = {
	['('] = function() return tkleftbracket, '('  end,
	[')'] = function() return tkrightbracket, ')' end,
	['['] = function() return tkleftsquarebracket, '[' end,
	[']'] = function() return tkrightsquarebracket, ']' end,
	['{'] = function() return tkleftbrace, '{' end,
	['}'] = function() return tkrightbrace, '}' end,
	['.'] = function() return tkdot, '.' end,
	[','] = function() return tkcomma, ',' end,
	['%'] = function() return tkmod, '%' end,
	['*'] = function() return tkmul, '*' end,
	['/'] = function() return tkdiv, '/' end,
	['+'] = function() return tkadd, '+' end,
	['-'] = function()  
		local w = string.sub(m.source, m.current + 1, m.current + 1)
		if w == '-' then m.current = m.current + 1 return tknote, '--' else return tksub, '-' end	
	end,
	[':'] = function() 
		local w = string.sub(m.source, m.current + 1, m.current + 1)
		if w == '=' then m.current = m.current + 1 return tknew, ':=' else return tkcolon, ':' end
	end,
	['<'] = function() 
		local w = string.sub(m.source, m.current + 1, m.current + 1)
		if w == '=' then 
			m.current = m.current + 1 return tklesseq, '<='
		elseif w == '>' then 
			m.current = m.current + 1 return tkuneq, '<>'
		else 
			return tkless, '<'
		end
	end,
	['>'] = function()
		local w = string.sub(m.source, m.current + 1, m.current + 1)
		if w == '=' then m.current = m.current + 1 return tkbigeq, '>=' else return tkbig, '>' end
	end,
	['='] = function()
		local w = string.sub(m.source, m.current + 1, m.current + 1)
		if w == '=' then m.current = m.current + 1 return tkeq, '=='  else return tkassign, '=' end
	end
}

function m.isaoperator(w)
	if simpletokentable[w] then return true else return false end	
end

function m.getnexttoken(b)
	local rl = m.line
	m.skipblankspace()
	if m.isend() then return tkend, rl + 1, rl end
	local state
	local w = string.sub(m.source, m.current, m.current)
	local c, l = m.current, m.line
	if w == '"' or w == "'"  then
		state = tkstring
	elseif isdigit(w) then
		state = tknumber
	elseif isalnum(w) or w == '_' then
		state = tkident
	end
	if state then
		m.tokenstring = m[state]()
		if state == tkident then
			if isupper(string.sub(m.tokenstring, 1, 1)) then
				state = tkclass
			elseif m[m.tokenstring] then 
				state = m[m.tokenstring] 
			end
		end
	elseif m.isaoperator(w) then
		state, m.tokenstring = simpletokentable[w]()
		m.current = m.current + 1
		if state ~= tknew and state ~= tkassign then state = tkident end 
	else
		m.error("getnexttoken() don't match that token")
	end

	if not b then 
		m.current = c
		m.line, l = l, m.line
	end
	return state, l, rl 
end

function m.match(token)
	if not token == m.getnexttoken(true) then m.error("match :"..token) end
end

return m 

