local ast = {}
local node = {}

function ast.newnode()
  local t = setmetatable({}, node)
  t.__index = node
  return t
end

ast.root = ast.newnode()
ast.current = ast.root

function ast.getroot()
  return ast.root
end

function ast.addnode(node)
	ast.current.next = node
	node.previ = ast.current
end

function ast.deletenode(node)
	if ast.current ~= ast.root then ast.current.prev = ast.current.next end
end

function ast.setcurrentnode(node)
	ast.current = node
end

function ast.getcurrentnode()
	return ast.current
end