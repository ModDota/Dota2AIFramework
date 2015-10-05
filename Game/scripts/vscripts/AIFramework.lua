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
require( 'AI.AIPlayerResource' )
require( 'AI.UnitWrapper' )
require( 'AI.AbilityWrapper' )
require( 'AI.AIUnitTests' )

--Class definition
if AIFramework == nil then
	AIFramework = class({})
end

--Initialisation
function AIFramework:Init()
	print( 'Initialising AI framework.' )

	--Make table to store vision dummies in
	AIFramework.visionDummies = {}

	--local ai1 = AIManager:InitAI( 'sample_ai', DOTA_TEAM_GOODGUYS, {'npc_dota_hero_sven'} )

	--GameRules:FinishCustomGameSetup()
	GameRules:SetCustomGameTeamMaxPlayers( 1, 	1 )

	Convars:SetInt( 'dota_auto_surrender_all_disconnected_timeout', 7200 )

	AIManager:Init()

	ListenToGameEvent( 'player_connect_full', Dynamic_Wrap( AIFramework, 'OnPlayerConnect' ), self )
	CustomGameEventManager:RegisterListener( 'spawn_ai', function() self:SpawnAI() end )
end

function AIFramework:OnPlayerConnect( event )
	PlayerResource:SetCustomTeamAssignment( event.index, 1 )

	AIManager.numPlayers = AIManager.numPlayers + 1
end

function AIFramework:SpawnAI( event )
	--Add some AI
	AIManager:AddAI( 'sample_ai', DOTA_TEAM_GOODGUYS, {'npc_dota_hero_sven'} )
	AIManager:AddAI( 'sample_ai', DOTA_TEAM_BADGUYS, {'npc_dota_hero_dazzle', 'npc_dota_hero_jakiro'} )
end
