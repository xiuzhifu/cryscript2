local Object = {}
Object.__index = Object
function Object.new()
	local t = setmetatable({}, Object)
	t.type = 'Object'	
	return t
end

function Object:print(...)
	if self and self['to_s'] then
		print(self['to_s'](self))
	else
		print(...)
	end
end

function Object:isparent(class)
	local t = self
	while true do
		if t.type == class then return true end
		if t.__index then
			t = t.__index
		else
			return false
		end
	end
end

return Object