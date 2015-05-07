require "lex"
local ObjectObject = require "objectObject"
local OperatorTable = ObjectObject.new()

local OperatorTable = {}

OperatorTable[1] = {'+', '-'}

OperatorTable[2] = {'%', '*', '/'}

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

return OperatorTable