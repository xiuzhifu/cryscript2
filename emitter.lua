local m = {}

instadd = 'instadd'
instsub = 'instsub'
instmul = 'instmul'
instdiv = 'instmul'

instclass = 'instclass'
instobject = 'instobject'
m.insts = [[
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
]]

function m.emit_object(object, parent)
	m.insts = m.insts.. string.format("getobject(%s, %s)", object, parent)
end

function m.emit_class(class)
	return string.format("getclass('%s')", class)
end

function m.emit_number(object)
	return string.format("getnumber(%s)", object)
end

function m.emit_string(object)
	return string.format("function() return getstring('%s') end\n", object)
end

function m.emit(inst, layer, left)
		print("emit:", inst, layer, left[2])
	local s = '	' , var, var1
	--m.insts =m.insts .. 'local var1, var2, var3, var4\n'
	if left[1] == tknumber then
		m.insts = m.insts ..m.emit_number(left[2])
	elseif left[1] == tkstring then
		var = 'var'..tostring(layer)
		s = s .. var ..' = '.. m.emit_string(left[2])
		if inst then 
			m.insts = m.insts .. s ..'	'..var..':'..inst..'()\n'
		else
			m.insts = m.insts .. s
		end
			var1 = function(s)
		if s then O.name = s end
		return O.name
	end
	elseif left[1] == tkclass then
		var = 'var'..tostring(layer)
		s = s.. var ..' = function(s) \n 		if s then ' ..left[2] .. '.'..inst..' = s end\n 		return '..left[2] .. '.'..inst..' end\n'
		m.insts = m.insts .. s
	end
	return 'var'..tostring(layer)
end

function m.emit_assign(layer, left, right, token)
	print("emit_assign:", layer, left, right, token)
	local s	
	if token == tkclass then
		s = '	'..left..' = '.. right..'\n'
	else
		s = '	'..left..' ('.. right..'())\n'
	end 
	m.insts = m.insts ..s
end
return m

