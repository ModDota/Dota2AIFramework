--[[
	AI Framework gamemode.
	This file contains the rules for a full AI game mode.

	Game mode: Default DotA.
	Idea: A regular game of dota.

	FixedDuration: No
	Duration: -

	FixedHeroes: Yes
	Heroes: 
		npc_dota_hero_nevermore
		npc_dota_hero_shadow_demon
		npc_dota_hero_sven
		npc_dota_hero_mirana
		npc_dota_hero_nyx_assassin

	Starting level: 1
	Starting gold: 625

	Win condition: Destroy the enemy ancient.
]]

--Create a gamemode object from the default gamemode object
local AIGameMode = BaseAIGameMode()

AIGameMode.NumPlayers = 5
AIGameMode.Heroes = {
	'npc_dota_hero_nevermore',
	'npc_dota_hero_shadow_demon',
	'npc_dota_hero_sven',
	'npc_dota_hero_mirana',
	'npc_dota_hero_nyx_assassin'
}

AIGameMode.StartingLevel = 1
AIGameMode.StartingGold = 625

function AIGameMode:Setup()
	print('DotA AI gamemode setup')
end

function AIGameMode:OnGameStart( teamHeroes )
	--Call to BaseAIGameMode setting up starting gold/level
	self:InitHeroes( teamHeroes )

	--Save the tower handles
	self.team1Ancient = Entities:FindByName( nil, 'dota_goodguys_fort' )
	self.team2Ancient = Entities:FindByName( nil, 'dota_badguys_fort' )

	--Listen to entity kills
	ListenToGameEvent( 'entity_killed', Dynamic_Wrap( AIGameMode, 'OnEntityKilled' ), self )
end

--entity_killed event handler
function AIGameMode:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )

	--Check for ancient kills
	if killedUnit == self.team1Ancient then
		--Call BaseAIGameMode functionality
		self:SetTeamWin( DOTA_TEAM_BADGUYS )
	elseif killedUnit == self.team2Ancient then
		--Call BaseAIGameMode functionality
		self:SetTeamWin( DOTA_TEAM_GOODGUYS )
	end
end

--Get extra data the AI can/needs to use for this challenge
function AIGameMode:GetExtraData( team )
	--No extra data
	return {}
end

return AIGameMode