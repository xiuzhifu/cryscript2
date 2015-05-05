local ast = require "ast"
local vm = {}

local Object = require "object"
local Number = require "number"
local stringObject = require "stringObject"
local objectpool = {}
local classpool = {}
classpool[Object.type] = Object
classpool[Number.type] = Number

function vm.execute()
	local node = ast.root.next
	while true do
		if node then
			tk = node.left[1]
			if tk == tknumber then
				node.object = Number.new()
				node.object.value = tonumber(node.left[2])
			elseif tk == tkstring then
				node.object = stringObject.new()
				node.object.s = node.left[2]
			elseif tk == tkclass then
				node.object = classpool[node.left[2]]		
			elseif tk == tkobject then			
			end

			if node.object[node.operator] then
				if type(node.object[node.operator]) == 'function' then
					node.result = node.object[node.operator](node.object)
				else
					node.result = node.object[node.operator]
				end
			end

			node = node.next
		else
			break
		end
	end
end
return vm