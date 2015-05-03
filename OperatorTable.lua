local Object = require "object"
local OperatorTable = Object.new()

local OperatorTable = {}

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

local tkend = 'tkend'
local tkident = 'tkident'
local tknumber = 'tknumber'
local tkfloat = 'tkfloat'
local tkstring = 'tkstring'
local tkoperator = 'tkoperator'
local tkleftbracket = 'tkleftbracket' --(
local tkrightbracket = 'tkrightbracket'--)
local tkleftsquarebracket = 'tkleftsquarebracket' --[
local tkrightsquarebracket = 'tkrightsquarebracket' --]
local tkleftbrace = 'tkleftbrace'--{
local tkrightbrace = 'tkrightbrace'--}
local tkdot = 'tkdot'
local tkand = 'tkand'
local tkor = 'tkor'
local tknot = 'tknot'
local tkmod = 'tkmod'
local tkdiv = 'tkdiv'
local tkmul = 'tkmul'
local tkadd = 'tkadd'
local tksub = 'tksub'
local tkeq = 'tkeq'
local tkless = 'tkless'
local tklesseq = 'tklesseq'
local tkbig = 'tkbig'
local tkbigeq = 'tkbigeq'
local tkuneq = 'tkuneq'
local tkassign = 'tkassign'
local tkcomma ='tkcomma'
local tkclass = 'tkclass'
local tkfunction = 'tkfunction'
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
			return true
		else
			return false
		end
	end
	return false
end
return OperatorTable