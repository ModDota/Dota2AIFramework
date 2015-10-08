--[[
	AI Framework gamemode.
	This file contains the base AI Game mode with default settings. These settings are then overriden in every
	specified gamemode.

	Defaults:
	FixedDuration: No
	Duration: 0

	NumPlayers: 1
	FixedHeroes: Yes
	Heroes: npc_dota_hero_sven

	Starting level: 1
	Starting gold: 625
]]
BaseAIGameMode = class({})

function BaseAIGameMode:constructor()

	--Set defaults
	self.NumTeams = 2
	self.Teams = { DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS }

	self.FixedDuration = false
	self.Duration = 0

	self.NumPlayers = 1
	self.FixedHeroes = true
	self.Heroes = {'npc_dota_hero_sven'}

	self.StartingLevel = 1
	self.StartingGold = 625

	return self
end

--Get extra data for the AI (like a description of the map) for a team
function BaseAIGameMode:GetExtraData( team )
	return {}
end

function BaseAIGameMode:InitHeroes( teamHeroes )
	for team, heroes in pairs( teamHeroes ) do
		self:SetupHeroes( heroes )
	end
end

function BaseAIGameMode:SetupHeroes( heroes )
	for _, hero in ipairs( heroes ) do
		--Give starting gold
		hero:SetGold( self.StartingGold, false )

		--Level up to the starting level
		while hero:GetLevel() < self.StartingLevel do
			if hero:GetLevel() == 1 then
				hero:HeroLevelUp( true )
			else
				hero:HeroLevelUp( false )
			end
		end
	end
end