--[[
	Dota 2 API Wrapper used to restrict access to functions by AI to keep the competition fair.
]]

--Class definition
if AIWrapper == nil then
	AIWrapper = class({ 
		constructor = function( self, team ) 
			self.team = team

			--TODO: make actual dummy that is out of the game
			self.teamDummy = CreateUnitByName( 'npc_dota_thinker', Vector(0,0,0), false, nil, nil, team )
		end
	})
end

--Private AIWrapper methods -TODO: Actually make private
--=======================================================================================================================
function InVision( unit )
	--return self.teamDummy:CanEntityBeSeenByMyTeam( unit )
	local bools = {true, false}
	return bools[RandomInt(1,2)]
end

local function WrapUnit( unit )
	--Check if we wrapped already
	if unit.wrapped ~= nil then
		return unit.wrapped
	end

	--Wrap the unit
	--Clone first
	local u = clone( unit )

	-- Set unit definition - Starts empty
	--=====================================================
	--GetAbsOrigin() -- Modified to take fog into account
	u.GetAbsOrigin = function( self )
		if InVision( unit ) then
			return unit:GetAbsOrigin()
		else
			return nil
		end
	end

	--Store the wrapped unit
	unit.wrapped = u

	--Return the wrapped unit
	return u
end



--Overrides
--=======================================================================================================================

--Overridden FindUnitsInRadius
function AIWrapper:FindUnitsInRadius( team, position, cacheUnit, radius, teamFilter, typeFilter, flagFilter, order, canGrowCache )
	local result = FindUnitsInRadius( team, position, cacheUnit, radius, teamFilter, typeFilter, flagFilter, order, canGrowCache )

	--Wrap result
	for k, unit in pairs( result ) do
		result[k] = WrapUnit( unit )
	end

	return result
end

function AIWrapper:Test()
	return 'boo'
end