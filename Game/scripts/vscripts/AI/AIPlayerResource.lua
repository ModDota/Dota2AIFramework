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