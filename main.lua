local ObjectObject = require "objectObject"
local NumberObject = require "numberObject"
local StringObject = require "stringObject"
local objectpool = {}
local classpool = {}
classpool[ObjectObject.type] = ObjectObject
classpool[NumberObject.type] = NumberObject
classpool[StringObject.type] = StringObject

local function getobject(object, parent)
	local o = objectpool[object]
	if not o then
		assert(classpool[parent], parent)
		o = classpool[parent].new()
	end
	return o
end

local function getclass(class)
	local c = classpool[class]
	if not c then
		c = ObjectObject.new()
		classpool[class] = c
		c.type = class
	end
	return c
end

local function getnumber(n)
	local o = getobject(n, 'Number')
	o.value = n
	return o
end

local function getstring(n)
	local o = getobject(n, 'String')
	o.s = n
	return o
end

local index = 0
local temp = {}
local function callvariable(addr, v)
	local t = temp[addr]
	t.object[v]()
	end
end


local function setvariable(addr, v)
	local t = temp[addr]
	if t.key then 
		t.object[t.key] = v
	else
		t.object = v
	end
end

local function getvariableaddr(o, k)
	index = index + 1
	if k then 
		temp[index] = {object = o, key = k}
	else
		temp[index] = {object = o, key = nil}	
	end
	return index
end

function main()
	temp3 = ObjectObject.new()
	O = temp3
	temp1 = getvariableaddr(O, "name")
	temp3 = getstring('anmeng')
	setvariable(temp1 , temp3)
	temp1 = getvariableaddr(O, "fackname")
	temp3 = getvariableaddr(O, "name")
	setvariable(temp1 , temp3)
	temp1 = getvariableaddr(O, "fackname")
	temp2 = getvariableaddr(temp1, "print")
end
main()
