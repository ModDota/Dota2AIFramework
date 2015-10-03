--[[
	Dota 2 API Wrapper used to restrict access to functions by AI to keep the competition fair.
]]

LinkLuaModifier( 'modifier_dummy', 'LuaModifiers/modifier_dummy', LUA_MODIFIER_MOTION_NONE )

--Class definition
if AIWrapper == nil then
	AIWrapper = class({ 
		constructor = function( self, team, global ) 
			self.team = team
		end
	})
end

--=======================================================================================================================
--AI-accessible functions
--=======================================================================================================================

--[[
	AIWrapper:FindUnitsInRadius( Team, Position, CacheUnit, Radius, TeamFilter, TypeFilter, FlagFilter, Order, CanGrowCache )
	Finds units in a radius with some parameters.

	Modification: Can only find units visible by the AI's team.
	Parameters:
		* Team
		* Position - The center of the circle to search in
		* CacheUnit - The cache unit.
		* Radius - The radius to search in
		* TeamFilter - DOTA_UNIT_TARGET_TEAM_* filter.
		* TypeFilter - DOTA_UNIT_TARGET_TYPE_* filter.
		* FlagFilter - DOTA_UNIT_TARGET_FLAG_* filter.
		* Order - The order to return results in.
		* CanGrowCache - Can the search grow the cache.
]]
function AIWrapper:FindUnitsInRadius( team, position, cacheUnit, radius, teamFilter, typeFilter, flagFilter, order, canGrowCache )

	--Add DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE to the flagFilter if it is not in
	if bit.band( flagFilter, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE ) == 0 then
		flagFilter = flagFilter + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE
	end

	--Do the search
	local result = FindUnitsInRadius( self.team, position, cacheUnit, radius, teamFilter, typeFilter, flagFilter, order, canGrowCache )

	--Wrap result units
	for k, unit in pairs( result ) do
		result[k] = WrapUnit( unit, self.team )
	end

	return result
end
