--[[
	AI Framework gamemode.
	This file contains the rules for a full AI game mode.

	Game mode: Farm Optimizer.
	Idea: Two AIs race on identical (but mirrored?) parts of an unknown map to farm the neutrals as fast as possible.

	FixedDuration: Yes
	Duration: 10m

	FixedHeroes: Yes
	Heroes: npc_dota_hero_antimage

	Starting level: 5
	Starting gold: 1500

	Win condition: Player with highest net worth at the end of the duration.
]]

--Create a gamemode object from the default gamemode object
local AIGameMode = BaseAIGameMode()

AIGameMode.FixedDuration = true
AIGameMode.Duration = 600

AIGameMode.Heroes = {'npc_dota_hero_antimage'}

AIGameMode.StartingLevel = 5
AIGameMode.StartingGold = 1500

function AIGameMode:OnGameStart( teamHeroes )
	--Call to BaseAIGameMode setting up starting gold/level
	self:InitHeroes( teamHeroes )

	--Save the only hero on each team for later
	self.team1Hero = teamHeroes[ DOTA_TEAM_GOODGUYS ][1]
	self.team2Hero = teamHeroes[ DOTA_TEAM_BADGUYS ][1]

	--Force the start of the game
	Tutorial:ForceGameStart()
end

--Get extra data the AI can/needs to use for this challenge
function AIGameMode:GetExtraData( team )
	local m = 1
	if team == DOTA_TEAM_GOODGUYS then
		m = -1
	end

	return {
		shop = Vector( 0, 0, 0 ),
		camps = {
			Vector( m * 500, 0, 0 ),
			Vector( m * 100, 500, 0 ),
			Vector( m * 1000, 1000, 0 ) 
		}
	}
end

return AIGameMode