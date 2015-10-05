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

--[[
	AIPlayerResource:GetConnectionState( playerID )
	Get connection state of a player.
	
	Modification: -
	Parameters: -
]]
function AIPlayerResource:GetConnectionState( playerID )
	return PlayerResource:GetConnectionState( playerID )
end

--[[
	AIPlayerResource:GetPlayerLoadedCompletely( playerID )
	Check if a player has loaded completely or not.
	
	Modification: -
	Parameters: -
]]
function AIPlayerResource:GetPlayerLoadedCompletely( playerID )
	return PlayerResource:GetPlayerLoadedCompletely( playerID )
end

--[[
	AIPlayerResource:GetTeam( playerID )
	Get the team of a player.
	
	Modification: -
	Parameters: -
]]
function AIPlayerResource:GetTeam( playerID )
	return PlayerResource:GetTeam( playerID )
end

--[[
	AIPlayerResource:GetSteamAccountID( playerID )
	Get the steam ID of a player.
	
	Modification: -
	Parameters: -
]]
function AIPlayerResource:GetSteamAccountID( playerID )
	return PlayerResource:GetSteamAccountID( playerID )
end

--[[
	AIPlayerResource:GetPlayerName( playerID )
	Get the name of a player.
	
	Modification: -
	Parameters: -
]]
function AIPlayerResource:GetPlayerName( playerID )
	return PlayerResource:GetPlayerName( playerID )
end

--[[
	AIPlayerResource:GetKills( playerID )
	Get the number of kills a player has.
	
	Modification: -
	Parameters: -
]]
function AIPlayerResource:GetKills( playerID )
	return PlayerResource:GetKills( playerID )
end

--[[
	AIPlayerResource:GetAssists( playerID )
	Get the number of assists a player has.
	
	Modification: -
	Parameters: -
]]
function AIPlayerResource:GetAssists( playerID )
	return PlayerResource:GetAssists( playerID )
end

--[[
	AIPlayerResource:GetDeaths( playerID )
	Get the number of deaths a player has.
	
	Modification: -
	Parameters: -
]]
function AIPlayerResource:GetDeaths( playerID )
	return PlayerResource:GetDeaths( playerID )
end

--[[
	AIPlayerResource:GetLevel( playerID )
	Get level of a player.
	
	Modification: -
	Parameters: -
]]
function AIPlayerResource:GetLevel( playerID )
	return PlayerResource:GetLevel( playerID )
end

--[[
	AIPlayerResource:GetGold( playerID )
	Get the amount of gold a player has.
	
	Modification: Only works for players on the AI's team.
	Parameters: -
]]
function AIPlayerResource:GetGold( playerID )
	if PlayerResource:GetTeam( playerID ) == self.team then
		return PlayerResource:GetGold( playerID )
	else
		return 0
	end
end

--[[
	AIPlayerResource:GetReliableGold( playerID )
	Get the amount of reliable gold a player has.
	
	Modification: Only works for players on the AI's team.
	Parameters: -
]]
function AIPlayerResource:GetReliableGold( playerID )
	if PlayerResource:GetTeam( playerID ) == self.team then
		return PlayerResource:GetReliableGold( playerID )
	else
		return 0
	end
end

--[[
	AIPlayerResource:GetUnreliableGold( playerID )
	Get the amount of unreliable gold a player has.
	
	Modification: Only works for players on the AI's team.
	Parameters: -
]]
function AIPlayerResource:GetUnreliableGold( playerID )
	if PlayerResource:GetTeam( playerID ) == self.team then
		return PlayerResource:GetUnreliableGold( playerID )
	else
		return 0
	end
end

--[[
	AIPlayerResource:GetLastHits( playerID )
	Get the number of last hits a player has.
	
	Modification: Only works for players on the AI's team.
	Parameters: -
]]
function AIPlayerResource:GetLastHits( playerID )
	if PlayerResource:GetTeam( playerID ) == self.team then
		return PlayerResource:GetLastHits( playerID )
	else
		return 0
	end
end

--[[
	AIPlayerResource:GetDenies( playerID )
	Get the number of denies a player has.
	
	Modification: Only works for players on the AI's team.
	Parameters: -
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
--[[
	AIPlayerResource:GetTeamKills( team )
	Get the amount of kills for a team.
	
	Modification: -.
	Parameters: -
]]
function AIPlayerResource:GetTeamKills( team )
	return PlayerResource:GetTeamKills( team )
end

--[[
	AIPlayerResource:GetNumCouriersForTeam( team )
	Get the amount of couriers for a team.
	
	Modification: Only works for own team.
	Parameters: -
]]
function AIPlayerResource:GetNumCouriersForTeam( team )
	if team == self.team then
		return PlayerResource:GetNumCouriersForTeam( team )
	else
		Warning( string.format( 'AI %i tried to get amount of couriers for team %i.', self.team, team ) )
	end
end

--[[
	AIPlayerResource:GetNthCourierForTeam( courierIndex, team )
	Get the n-th courier for a team.
	
	Modification: Only works for own team.
	Parameters: -
]]
function AIPlayerResource:GetNthCourierForTeam( courierIndex, team )
	if team == self.team then
		return PlayerResource:GetNthCourierForTeam( courierIndex, team )
	else
		Warning( string.format( 'AI %i tried to get courier from team %i.', self.team, team ) )
	end
end

--[[
	AIPlayerResource:GetNthPlayerIDOnTeam( team, n )
	Get the n-th player on a team.
	
	Modification: -.
	Parameters: -
]]
function AIPlayerResource:GetNthPlayerIDOnTeam( team, n )
	return PlayerResource:GetNthPlayerIDOnTeam( team, n )
end

--[[
	AIPlayerResource:GetPlayerCount()
	Get the playercount including spectators.
	
	Modification: -.
	Parameters: -
]]
function AIPlayerResource:GetPlayerCount()
	return PlayerResource:GetPlayerCount()
end

--[[
	AIPlayerResource:GetPlayerForTeam( team )
	Get the playercount for a team.
	
	Modification: -.
	Parameters: -
]]
function AIPlayerResource:GetPlayerCountForTeam( team )
	return PlayerResource:GetPlayerCountForTeam( team )
end

--[[
	AIPlayerResource:GetTeamPlayerCount( team )
	Get the playercount (not abandonned) for a valid team.
	
	Modification: -.
	Parameters: -
]]
function AIPlayerResource:GetTeamPlayerCount( team )
	return PlayerResource:GetTeamPlayerCount( team )
end