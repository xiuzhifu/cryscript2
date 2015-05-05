local ast = require "ast"

local Object = require "object"
local Number = require "number"
local String = require "string"
local objectpool = {}
local classpool = {}
classpool[Object.type] = Object
classpool[Number.type] = Number
local m = {}
function m.emit_object(name, parent)
	print(parent.."object:"..name)
	local n = ast.newnode()
	ast.addnode(n)
	ast.setcurrentnode(n)
	n.operator = 'Object'
	n.left = name
	n.right = parent 
	return n
end

function m.emit_class(name, parent)
	print("class:"..name)
	local n = ast.newnode()
	ast.addnode(n)
	ast.setcurrentnode(n)
	n.operator = 'Class'
	n.left = name
	n.right = parent
	return n
end

function m.emit_number(s)
	return m.emit_object(s, 'Number')
end

function m.emit_string(s)
	return m.emit_object(s, 'String')
end

function m.emit_operator(op, object, var)
	local n = ast.newnode()
	ast.addnode(n)
	ast.setcurrentnode(n)
	n.left = object
	n.right = var
	n.operator = op
	print("operator:", op, object[2], var)
	return n
end
return m

