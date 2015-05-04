local ast = require "ast"
local vm = {}

function vm.execute()
	local node = ast.root.next
	while true do
		if node then
			node.operator(node.left, node.right, node)
			node = node.next
		else
			break
		end
	end
end
return vm