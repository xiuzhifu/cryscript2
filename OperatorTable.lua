local Object = require "object"
local OperatorTable = Object.new()
local Number.value = 0 
local function Number.to_s()
	return tostring(Number.value)
end

local operatortable = {}
operatortable[2] = {
  [tkmod] = operator_mod,
  [tkmul] = operator_mul,
  [tkdiv] = operator_div
}

operatortable[3] = {
  [tkadd] = operator_add, 
  [tksub] = operator_sub
}

operatortable[5] = {
  [tkless] = operator_less, 
  [tklesseq] = operator_lesseq,
  [tkbig] = operator_big,
  [tkbigeq] = operator_bigeq,
}

operatortable[6] = {
  [tkuneq] = operator_uneq,
  [tkeq] = operator_eq
}

operatortable[7] = {
  [tkor] = operator_or
}

operatortable[8] = {
  [tkand] = operator_and
}

local function operator_add()
end

local function operator_sub()
end

local function operator_mul()
end

local function operator_div()
end

local function operator_mod()
end

local function operator_less()
end

local function operator_lesseq()
end

local function operator_big()

end

local function operator_bigeq()

end

local function operator_noteq()

end

local function operator_eq()

end

local function operator_or()

end

local function operator_and()

end
return OperatorTable