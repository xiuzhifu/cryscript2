local Object = require "object"
local Number = Object.new()
local Number.value = 0 
local function Number.to_s()
	return tostring(Number.value)
end
return Number