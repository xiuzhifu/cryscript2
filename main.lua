local ObjectObject = require "objectObject"
local NumberObject = require "numberObject"
local stringObject = require "stringObject"
local objectpool = {}
local classpool = {}
classpool[ObjectObject.type] = ObjectObject
classpool[NumberObject.type] = NumberObject
classpool[stringObject.type] = stringObject

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

function main()
	var3 = function(s) 
 		if s then ObjectObject.new = s end
 		return ObjectObject.new end
	O = var3
	var1 = function(s) 
 		if s then O.name = s end
 		return O.name end
	var3 = function() return getstring('anmeng') end
	var1 (var3())
	var1 = function(s) 
 		if s then O.fackname = s end
 		return O.fackname end
	var3 = function(s) 
 		if s then O.name = s end
 		return O.name end
	var1 (var3())
	var1 = function(s) 
 		if s then O.fackname = s end
 		return O.fackname end
	var2 = function(s) 
 		if s then var1.print = s end
 		return var1.print end
end
main()
