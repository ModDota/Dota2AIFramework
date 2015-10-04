--[[
	Unit Wrapper.

	This file contains the wrapper for dota 2 units. A facade is created to
	provide only certain unit functionality to AI. 

	Code: Perry
	Date: October, 2015
]]


--Determine if a unit is in a team's vision
function InVision( unit, team )
	return AIManager.visionDummies[ team ]:CanEntityBeSeenByMyTeam( unit )
end

--Wrap a unit for a set team
function WrapUnit( unit, team )
	--Check if we wrapped already
	if unit.wrapped ~= nil then
		return unit.wrapped
	end

	--Create facade unit
	local u = {}

	--Add functionality to the unit
	UnitSetup( u, unit, team )

	--Store the wrapped unit
	unit.wrapped = u

	--Return the wrapped unit
	return u
end

--====================================================================================================
-- Define Unit functionality
--====================================================================================================
function UnitSetup( unit, globalUnit, team )

	--[[
		unit:GetAbsOrigin()
		Get the position of the unit.

		Modification: Return nil when unit is in fog of war.
		Parameters: -
	]]
	function unit:GetAbsOrigin()
		if InVision( unit, team ) then
			return globalUnit:GetAbsOrigin()
		else
			return nil
		end
	end

	--[[
		unit:GetAbilityByIndex( index )
		Retrieve an ability by index from the unit.
		
		Modification: -
		Parameters: -
	]]
	function unit:GetAbilityByIndex( index )
		return WrapAbility( globalUnit:GetAbilityByIndex( index ), team )
	end

	--[[
		unit:GetPlayerOwnerID()
		Get the ID of the player owning this unit.

		Modification: -
		Parameters: -
	]]
	function unit:GetPlayerOwnerID()
		return globalUnit:GetPlayerOwnerID()
	end
end