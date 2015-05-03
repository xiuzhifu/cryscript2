local Object = require "object"
local Number = Object.new()
Number.value = 0 
function Number.to_s()
	return tostring(Number.value)
end
return Number