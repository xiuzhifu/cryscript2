require "lex"
local Object = require "object"
local Number = require "Number"
local OperatorTable = Object.new()

local OperatorTable = {}

local function operator_add(a, b, result)
	local l, r 
	if a.type == 'Node' then a = a.result end
	if b.type == 'Node' then b = b.result end

	if a.type == "Number" then l = a.value end
	if b.type == "Number" then r = b.value end

	result.result = Number.new()
	result.result.value = l + r
	print(a.type, b.type, result.result.value)
end

local function operator_sub(a, b, result)
	local l, r 
	if a.type == 'Node' then a = a.result end
	if b.type == 'Node' then b = b.result end

	if a.type == "Number" then l = a.value end
	if b.type == "Number" then r = b.value end

	result.result = Number.new()
	result.result.value = l - r
	print(a.type, b.type, result.result.value)
end

local function operator_mul(a, b, result)
	local l, r 
	if a.type == 'Node' then a = a.result end
	if b.type == 'Node' then b = b.result end

	if a.type == "Number" then l = a.value end
	if b.type == "Number" then r = b.value end

	result.result = Number.new()
	result.result.value = l * r
	print(a.type, b.type, result.result.value)
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

OperatorTable[1] = {
  [tkadd] = operator_add, 
  [tksub] = operator_sub
}

OperatorTable[2] = {
  [tkmod] = operator_mod,
  [tkmul] = operator_mul,
  [tkdiv] = operator_div
}

-- OperatorTable[3] = {
--   [tkless] = operator_less, 
--   [tklesseq] = operator_lesseq,
--   [tkbig] = operator_big,
--   [tkbigeq] = operator_bigeq,
-- }

-- OperatorTable[4] = {
--   [tkuneq] = operator_uneq,
--   [tkeq] = operator_eq
-- }

-- OperatorTable[5] = {
--   [tkor] = operator_or
-- }

-- OperatorTable[6] = {
--   [tkand] = operator_and
-- }


function OperatorTable.isinthislevel(op, level)
	-- print(op, level)
	if OperatorTable[level] then
		if OperatorTable[level][op] then
			return true, OperatorTable[level][op]
		else
			return false
		end
	end
	return false
end

function OperatorTable.getop( ... )
	-- body
end
return OperatorTable