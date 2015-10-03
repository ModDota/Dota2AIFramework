--[[
	AI Competition framework.

	This is the main class of the Dota 2 AI competition framework developed for the purpose of holding
	AI competitions where AI players are presented with tasks in Dota 2 to accomplish as well as possible
	without a human intervening.

	Code: Perry
	Date: October, 2015
]]

--Include AI
require( 'AI.AIManager' )
require( 'AI.AIWrapper' )
require( 'AI.AIEvents' )
require( 'AI.UnitWrapper' )
require( 'AI.AbilityWrapper' )

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

