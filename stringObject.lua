local Object = require "objectObject"
local m = Object.new()
m.__index = m
m.type = 'String'
function m.new()
	local t = setmetatable({}, m)
	t.type = 'String'
	t.s = nil
	return t
end

function m:to_s()
	return self.s
end
return m