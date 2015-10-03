--[[
	Some fancy comment block.
]]

--Class definition
if AIFramework == nil then
	AIFramework = class({})
end

--Initialisation
function AIFramework:Init()
	print( 'Initialising AI framework.' )

	--Make table to store vision dummies in
	AIFramework.visionDummies = {}

	local ai1 = AIManager:InitAI( 'sample_ai', DOTA_TEAM_GOODGUYS )
end

