local Object = {}
function Object.new()
	local t = setmetatable({}, Object)
	t.type = 'Object'
	t.__index = Object
	return t
end
return Object