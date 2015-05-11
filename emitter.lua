local m = {}

instadd = 'instadd'
instsub = 'instsub'
instmul = 'instmul'
instdiv = 'instmul'

instclass = 'instclass'
instobject = 'instobject'

local objectpool = {}
local symboltable = {}

local function findprop(o, k)
	if o.k then return true else return false end
end

function m.emit_object(object, parent, owner)
  symboltable.objects[object] = {
    ['parent'] = parent,
    ['owner'] = owner,
    ['end'] = false,
		['function'] = {},
		['start'] = {}
  }  
  
end

function m.emit_object_end(objectname)
  symboltable.objects[objectname]['end'] = true
end

function m.emit_function_start(object, funcname)
end

function m.emit_function_param(object, funcname, param)
end

function m.is_function(object, funcname)
		local o = symboltable.objects[object]
		if o['function'][funcname] then return true else return false end
end

function m.is_variable(object, name)
  local o = symboltable.objects[object]
  if o['variable'][name] then return true else return false end
end

function m.emit_object_variable(object, left, right)
end

function m.emit_command(object, funcname, inst, left, layer)

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

