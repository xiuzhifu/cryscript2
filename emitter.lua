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
]]

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

local runtime = {}
local objectlist = {}
local varlist = {}
local localvarlist = {}
local functionlist = {}
local function init()
	local ObjectObject = require "objectObject"
	local NumberObject = require "numberObject"
	local StringObject = require "stringObject"
	objectlist['ObjectObject'] = ObjectObject
	objectlist['NumberObject'] = NumberObject
	objectlist['StringObject'] = StringObject
	
	
	objectlist[ObjectObject.type] = ObjectObject
	objectlist[NumberObject.type] = NumberObject
	objectlist[StringObject.type] = StringObject

	varlist['ObjectObject'] = {}
	varlist['NumberObject'] = {}
	varlist['StringObject'] = {}	

	functionlist['ObjectObject'] = {}
	functionlist['NumberObject'] = {}
	functionlist['StringObject'] = {}	
	for k,v in pairs(ObjectObject) do
		if type(v) == 'function' then
			functionlist['ObjectObject'][k] = true
		else
			varlist['ObjectObject'][k] = true
		end
	end

	for k,v in pairs(NumberObject) do
		if type(v) == 'function' then
			functionlist['NumberObject'][k] = true
		else
			varlist['NumberObject'][k] = true
		end
	end

	for k,v in pairs(StringObject) do
		if type(v) == 'function' then
			functionlist['StringObject'][k] = true
		else
			varlist['StringObject'][k] = true
		end
	end
end
init()

local function findprop(o, k)
	if o.k then return true else return false end
end

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
	return string.format("getstring('%s')", object)
end

function m.emit(inst, layer, left)
		print("emit:", inst, layer, left[2])
	local s = '	' , var, var1
	--m.insts =m.insts .. 'local var1, var2, var3, var4\n'
	if left[1] == tknumber then
		m.insts = m.insts ..m.emit_number(left[2])
	elseif left[1] == tkstring then
		var = 'temp'..tostring(layer)
		runtime[var] = getstring(left[2])
		s = s .. var ..' = '.. m.emit_string(left[2])
		if inst then 
			runtime[var][inst](runtime[var])
			m.insts = m.insts .. s ..'	'..var..':'..inst..'()\n'
		else
			m.insts = m.insts .. s..'\n'
		end
	elseif left[1] == tkclass then
		
		var = 'temp'..tostring(layer)
		local n = left[2]
		if functionlist[n] and  functionlist[n][inst] then
			s = s.. var ..' = '..n .. '.'..inst..'()\n'
			runtime[var] = objectlist[n][inst](objectlist[n])
		else
			if not runtime[n][inst] then
				runtime[n][inst] = {object = n, key = inst}
			end
			runtime[var] = runtime[n][inst]
			s = s.. var ..' = '..n .. ', "'..inst..'"\n'
		end
		m.insts = m.insts .. s
		
		
	end
	return 'temp'..tostring(layer)
end

function m.emit_assign(layer, left, right, token)
	print("emit_assign:", layer, left, right, token)
	local s	
	if token == tkclass then 
	runtime[left] = runtime[right]
		
		s = '	'..left..' = '.. right..'\n'
	else
		objectlist[runtime[left].object].[runtime[left].key] = runtime[right]
		s = '	setvariable('..left..' , '.. right..')\n'
	end
	m.insts = m.insts ..s
end
return m

