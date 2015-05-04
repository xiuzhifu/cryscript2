local ast = require "ast"

local Object = require "object"
local Number = require "number"
local objectpool = {}
local m = {}

function m.emit_object(name)
	local o = Object.new()
	objectpool[name] = o
	o.type = name
	return o
	--local n = ast.newnode()
end

function m.emit_callfunction(tk, s, funcname)
	local n = ast.newnode()
	ast.addnode(n)
	ast.setcurrentnode(n)
	local o
	if tk == tknumber then
		o = Number.new()
		o.value = tonumber(s) 
	elseif tk == tknode then
		o = s
	end
	n.left = o
	n.right = funcname
	n.operator = function(left, right, node)
		local f
		print(node.left, node.left.type, node.right, node.left.value)
		if node.left.type == 'Node' then 
			f = node.left.result 
		elseif node.left.type == 'Number' then
			f = node.left
		end
		if f[node.right] then f[node.right](f) else print("Not found function: "..node.right) end
	end
	return "tknode", n
end

function m.emit_assign( ... )
	-- body
end

function m.emit_exp(tkfunc, tk1, s1, tk2, s2)
	local n = ast.newnode()
	local o1, o2
	if tk1 == tknumber then
		o1 = Number.new()
		o1.value = tonumber(s1) 
	elseif tk1 == tknode then
		o1 = s1
	end

	if tk2 == tknumber then
		o2 = Number.new()
		o2.value = tonumber(s2)
	elseif tk2 == tknode then
		o2 = s2
	end

	n.left = o1
	n.right = o2
	n.operator = tkfunc
	ast.addnode(n)
	ast.setcurrentnode(n)
	return "tknode", n
end

return m

