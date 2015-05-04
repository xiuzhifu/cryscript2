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

return Object