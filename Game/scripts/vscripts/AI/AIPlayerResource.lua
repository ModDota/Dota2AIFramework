--[[
	AIPlayerResource

	This file contains a facade for PlayerResource which is exposed to AI. This limits
	the functionality the AI has access to.

	Code: Perry
	Date: October, 2015
]]

AIPlayerResource = class({})

function AIPlayerResource:constructor( team )
	self.team = team
end

--[[[
	@func AIPlayerResource:GetConnectionState( playerID )
	@desc Get connection state of a player.
	
	@modification -
	@param {integer} playerID The ID of the player.
]]
function AIPlayerResource:GetConnectionState( playerID )
	return PlayerResource:GetConnectionState( playerID )
end

--[[[
	@func AIPlayerResource:GetPlayerLoadedCompletely( playerID )
	@desc Check if a player has loaded completely or not.
	
	@modification -
	@param {integer} playerID The ID of the player.
]]
function AIPlayerResource:GetPlayerLoadedCompletely( playerID )
	return PlayerResource:GetPlayerLoadedCompletely( playerID )
end

--[[[
	@func AIPlayerResource:GetTeam( playerID )
	@desc Get the team of a player.
	
	@modification -
	@param {integer} playerID The ID of the player.
]]
function AIPlayerResource:GetTeam( playerID )
	return PlayerResource:GetTeam( playerID )
end

--[[[
	@func AIPlayerResource:GetSteamAccountID( playerID )
	@desc Get the steam ID of a player.
	
	@modification -
	@param {integer} playerID The ID of the player.
]]
function AIPlayerResource:GetSteamAccountID( playerID )
	return PlayerResource:GetSteamAccountID( playerID )
end

--[[[
	@func AIPlayerResource:GetPlayerName( playerID )
	@desc Get the name of a player.
	
	@modification -
	@param {integer} playerID The ID of the player.
]]
function AIPlayerResource:GetPlayerName( playerID )
	return PlayerResource:GetPlayerName( playerID )
end

--[[[
	@func AIPlayerResource:GetKills( playerID )
	@desc Get the number of kills a player has.
	
	@modification -
	@param {integer} playerID The ID of the player.
]]
function AIPlayerResource:GetKills( playerID )
	return PlayerResource:GetKills( playerID )
end

--[[[
	@func AIPlayerResource:GetAssists( playerID )
	@desc Get the number of assists a player has.
	
	@modification -
	@param {integer} playerID The ID of the player.
]]
function AIPlayerResource:GetAssists( playerID )
	return PlayerResource:GetAssists( playerID )
end

--[[[
	@func AIPlayerResource:GetDeaths( playerID )
	@desc Get the number of deaths a player has.
	
	@modification -
	@param {integer} playerID The ID of the player.
]]
function AIPlayerResource:GetDeaths( playerID )
	return PlayerResource:GetDeaths( playerID )
end

--[[[
	@func AIPlayerResource:GetLevel( playerID )
	@desc Get level of a player.
	
	@modification -
	@param {integer} playerID The ID of the player.
]]
function AIPlayerResource:GetLevel( playerID )
	return PlayerResource:GetLevel( playerID )
end

--[[[
	@func AIPlayerResource:GetGold( playerID )
	@desc Get the amount of gold a player has.
	
	@modification Only works for players on the AI's team.
	@param {integer} playerID The ID of the player.
]]
function AIPlayerResource:GetGold( playerID )
	if PlayerResource:GetTeam( playerID ) == self.team then
		return PlayerResource:GetGold( playerID )
	else
		return 0
	end
end

--[[[
	@func AIPlayerResource:GetReliableGold( playerID )
	@desc Get the amount of reliable gold a player has.
	
	@modification Only works for players on the AI's team.
	@param {integer} playerID The ID of the player.
]]
function AIPlayerResource:GetReliableGold( playerID )
	if PlayerResource:GetTeam( playerID ) == self.team then
		return PlayerResource:GetReliableGold( playerID )
	else
		return 0
	end
end

--[[[
	@func AIPlayerResource:GetUnreliableGold( playerID )
	@desc Get the amount of unreliable gold a player has.
	
	@modification Only works for players on the AI's team.
	@param {integer} playerID The ID of the player.
]]
function AIPlayerResource:GetUnreliableGold( playerID )
	if PlayerResource:GetTeam( playerID ) == self.team then
		return PlayerResource:GetUnreliableGold( playerID )
	else
		return 0
	end
end

--[[[
	@func AIPlayerResource:GetLastHits( playerID )
	@desc Get the number of last hits a player has.
	
	@modification Only works for players on the AI's team.
	@param {integer} playerID The ID of the player.
]]
function AIPlayerResource:GetLastHits( playerID )
	if PlayerResource:GetTeam( playerID ) == self.team then
		return PlayerResource:GetLastHits( playerID )
	else
		return 0
	end
end

--[[[
	@func AIPlayerResource:GetDenies( playerID )
	@desc Get the number of denies a player has.
	
	@modification Only works for players on the AI's team.
	@param {integer} playerID The ID of the player.
]]
function AIPlayerResource:GetDenies( playerID )
	if PlayerResource:GetTeam( playerID ) == self.team then
		return PlayerResource:GetDenies( playerID )
	else
		return 0
	end
end

--Team functions
--==============================================================================
--[[[
	@func AIPlayerResource:GetTeamKills( team )
	@desc Get the amount of kills for a team.
	
	@modification -
	@param {integer} team The number of the team.
]]
function AIPlayerResource:GetTeamKills( team )
	return PlayerResource:GetTeamKills( team )
end

--[[[
	@func AIPlayerResource:GetNumCouriersForTeam( team )
	@desc Get the amount of couriers for a team.
	
	@modification Only works for own team.
	@param {integer} team The number of the team.
]]
function AIPlayerResource:GetNumCouriersForTeam( team )
	if team == self.team then
		return PlayerResource:GetNumCouriersForTeam( team )
	else
		Warning( string.format( 'AI %i tried to get amount of couriers for team %i.', self.team, team ) )
	end
end

--[[[
	@func AIPlayerResource:GetNthCourierForTeam( courierIndex, team )
	@desc Get the n-th courier for a team.
	
	@modification Only works for own team.
	Parameters: -
]]
function AIPlayerResource:GetNthCourierForTeam( courierIndex, team )
	if team == self.team then
		return PlayerResource:GetNthCourierForTeam( courierIndex, team )
	else
		Warning( string.format( 'AI %i tried to get courier from team %i.', self.team, team ) )
	end
end

--[[[
	@func AIPlayerResource:GetNthPlayerIDOnTeam( team, n )
	@desc Get the n-th player on a team.
	
	@modification -
	@param {integer} team The number of the team.
	@param {integer} n The index of the courier to get.
]]
function AIPlayerResource:GetNthPlayerIDOnTeam( team, n )
	return PlayerResource:GetNthPlayerIDOnTeam( team, n )
end

--[[[
	@func AIPlayerResource:GetPlayerCount()
	@desc Get the playercount including spectators.
	
	@modification -
]]
function AIPlayerResource:GetPlayerCount()
	return PlayerResource:GetPlayerCount()
end

--[[[
	@func AIPlayerResource:GetPlayerForTeam( team )
	@desc Get the playercount for a team.
	
	@modification -
	@param {integer} team The number of the team.
]]
function AIPlayerResource:GetPlayerCountForTeam( team )
	return PlayerResource:GetPlayerCountForTeam( team )
end

--[[[
	@func AIPlayerResource:GetTeamPlayerCount( team )
	@desc Get the playercount (not abandonned) for a valid team.
	
	@modification -
	@param {integer} team The number of the team.
]]
function AIPlayerResource:GetTeamPlayerCount( team )
	return PlayerResource:GetTeamPlayerCount( team )
end