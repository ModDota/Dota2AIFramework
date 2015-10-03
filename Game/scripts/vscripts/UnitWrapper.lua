--[[
	Unit wrapping functions.
]]

--Determine if a unit is in a team's vision
function InVision( unit, team )
	return AIFramework.visionDummies[ team ]:CanEntityBeSeenByMyTeam( unit )
end

--Wrap a unit for a set team
function WrapUnit( unit, team )
	--Check if we wrapped already
	if unit.wrapped ~= nil then
		return unit.wrapped
	end

	--Wrap the unit
	--Clone first to preserve any data stored on the unit (-should always be wrapped first so redundant?)
	local u = clone( unit )

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
end