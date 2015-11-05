--[[
	AI Framework gamemode.
	This file contains the rules for a full AI game mode.

	Game mode: 1v1 Mid.
	Idea: Two AI players battle at mid lane. The winner is the AI that kills the other twice or 
	destroys the first tower.

	FixedDuration: No
	Duration: -

	FixedHeroes: Yes
	Heroes: npc_dota_hero_nevermore

	Starting level: 1
	Starting gold: 625

	Win condition: The player that kills the other player twice or pushes mid tower first.
]]

--Create a gamemode object from the default gamemode object
local AIGameMode = BaseAIGameMode()

AIGameMode.Heroes = {'npc_dota_hero_nevermore'}

AIGameMode.StartingLevel = 1
AIGameMode.StartingGold = 625

function AIGameMode:Setup()
	print('1v1Mid Setup')

	--Set pre game time
	GameRules:SetPreGameTime( 35.0 )

	--Disable side lanes
	Convars:SetBool( 'dota_disable_bot_lane', true )
	Convars:SetBool( 'dota_disable_top_lane', true )
end

function AIGameMode:OnGameStart( teamHeroes )
	--Call to BaseAIGameMode setting up starting gold/level
	self:InitHeroes( teamHeroes )

	--Save the only hero on each team for later
	self.team1Hero = teamHeroes[ DOTA_TEAM_GOODGUYS ][1]
	self.team2Hero = teamHeroes[ DOTA_TEAM_BADGUYS ][1]

	--Save the tower handles
	self.team1Tower = Entities:FindByName( nil, 'dota_goodguys_tower1_mid' )
	self.team2Tower = Entities:FindByName( nil, 'dota_badguys_tower1_mid' )

	--Listen to entity kills
	ListenToGameEvent( 'entity_killed', Dynamic_Wrap( AIGameMode, 'OnEntityKilled' ), self )
end

--entity_killed event handler
function AIGameMode:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )

	--Check for towers
	if killedUnit == self.team1Tower then
		--Call BaseAIGameMode functionality
		self:SetTeamWin( DOTA_TEAM_BADGUYS )
	elseif killedUnit == self.team2Tower then
		--Call BaseAIGameMode functionality
		self:SetTeamWin( DOTA_TEAM_GOODGUYS )
	end

	--Check hero kills
	if killedUnit == self.team1Hero or killedUnit == self.team2Hero then
		if PlayerResource:GetKills( self.team1Hero:GetPlayerOwnerID() ) >= 2 then
			--Call BaseAIGameMode functionality
			self:SetTeamWin( DOTA_TEAM_GOODGUYS )
		elseif PlayerResource:GetKills( self.team2Hero:GetPlayerOwnerID() ) >= 2 then
			--Call BaseAIGameMode functionality
			self:SetTeamWin( DOTA_TEAM_BADGUYS )
		end
	end
end

--Get extra data the AI can/needs to use for this challenge
function AIGameMode:GetExtraData( team )
	--No extra data
	return {}
end

return AIGameMode