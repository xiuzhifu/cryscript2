local source = '5+8*2-4#'
local currenttoken = 1
local operator = {}

operator['+'] = add
operator['-'] = sub
operator['*'] = mul
operator['/'] = div

-- term -> num *|/ num 
-- 		factor

-- factor -> num + - 
-- 		factor

function add()
end

function sub()
end

function mul()
end

function div()
end

local tknumber = 'number'
local tkop1 = 'op1'
local tkop2 = 'op2'f
local level = {}
level[1] = {'*', '/'}
level[2] = {'+', '-'}

function isalpha()

end

function isnumber(n)
	local s = '0123456789'
	for i = 1, 10 do
	if n == string.sub(s,i,i) then return true end 
	end
  return false
end

function isop1(o)
  if o == '*' or o == '/' then return true else return false end
end

function  isop2(o)
  if o == '+' or o == '-' then return true else return false end
end

function getcurrenttoken()
	local s = string.sub(source,currenttoken,currenttoken)
  	if s == '#' then return false
  	elseif isnumber(s) then return tknumber 
  	elseif isop1(s) then return tkop1 
    elseif isop2(s) then return tkop2 end
  	return false
end

function getcurrentstring()
	return string.sub(source,currenttoken,currenttoken)
end

function getnextstring()
	return string.sub(source,currenttoken + 1,currenttoken + 1)
end

function getnexttoken()
	local s = string.sub(source,currenttoken + 1,currenttoken + 1)
  	if s == '#' then return false
  	elseif isnumber(s) then return tknumber 
  	elseif isop1(s) then return tkop1 
    elseif isop2(s) then return tkop2 end
  	return false
end

function exp()
	factor()
end
local t = 0
function term()
	t = t + 1
	if getnexttoken() == tkop1 then
		print(getnextstring(), t)
		print(getcurrentstring(), t)
		match(tknumber, 'term')
		match(tkop1, 'term')
		term()
	elseif not getnexttoken() then 
		match(tknumber, 'gg')
		print(getcurrentstring(), 'gg')
		return
	factor()
	end
end

function factor()
	local s = getnexttoken()
	
	if getnexttoken() == tkop2 then
		print(getnextstring(), 'f')
		print(getcurrentstring(), 'f')
		match(tknumber, 'factor')
		match(tkop2, 'factor')
		term()
		print(getcurrentstring(), 'ff')
		
	end
	if not getnexttoken() then 
		match(tknumber, 'ggg')
		print(getcurrentstring(), 'ggg')
	return 
	else
		term()
	end
end
local mc = 0
 
function match(s, e)
	mc = mc + 1
	print(s, getcurrenttoken(), getcurrentstring(), mc, e)
	if s == getcurrenttoken() then 
		--print(getcurrentstring())
		currenttoken = currenttoken + 1				
		return true 
	end
	if e then 
		print("match failed\n", s, e, mc) 
	else
		print("match failed\n", s, mc)
	end
	return false
end

function main()
	print(source)
exp()
end
main()
