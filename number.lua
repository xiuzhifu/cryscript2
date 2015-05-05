local Object = require "object"
local Number = Object.new()
Number.__index = Number
function Number.new()
	local t = setmetatable({}, Number)
	t.type = 'Number'
	t.__index = Number
	t.value = 0
	return t
end
function Number:to_s()
	return tostring(self.value)
end
Number['+'] = function(left, right, result)
	assert(left:isparent("Number"))
	assert(right:isparent("Number"))
	left.value = right.value + left.value
end

Number['-'] = function(left, right, result)
	assert(left:isparent("Number"))
	assert(right:isparent("Number"))
	left.value = right.value - left.value
end

Number['*'] = function(left, right, result)
	assert(left:isparent("Number"))
	assert(right:isparent("Number"))
	left.value = right.value * left.value
end

Number['/'] = function(left, right, result)
	assert(left:isparent("Number"))
	assert(right:isparent("Number"))
	left.value = right.value / left.value
end

return Number