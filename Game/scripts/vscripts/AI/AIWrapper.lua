--[[
	AI Wrapper.

	This file contains the wrapper for dota 2 AI. The main purpose is to hide any normal
	server-side functionality and provide the AI with a subset of that. Delegates wrapping
	units and abilities to UnitWrapper and AbilityWrapper respectively.

	Code: Perry
	Date: October, 2015
]]


LinkLuaModifier( 'modifier_dummy', 'LuaModifiers/modifier_dummy', LUA_MODIFIER_MOTION_NONE )

--Class definition
if AIWrapper == nil then
	AIWrapper = class({})
end

--Constructor
function AIWrapper:constructor( team )
	self.team = team
end

--=======================================================================================================================
--AI-accessible functions
--=======================================================================================================================

--[[
	AI_FindUnitsInRadius( Position, CacheUnit, Radius, TeamFilter, TypeFilter, FlagFilter, Order, CanGrowCache )
	Finds units in a radius with some parameters.

	Modification: Can only find units visible by the AI's team.
	Parameters:
		* Position - The center of the circle to search in
		* CacheUnit - The cache unit.
		* Radius - The radius to search in
		* TeamFilter - DOTA_UNIT_TARGET_TEAM_* filter.
		* TypeFilter - DOTA_UNIT_TARGET_TYPE_* filter.
		* FlagFilter - DOTA_UNIT_TARGET_FLAG_* filter.
		* Order - The order to return results in.
		* CanGrowCache - Can the search grow the cache.
]]
function AIWrapper:AI_FindUnitsInRadius( position, cacheUnit, radius, teamFilter, typeFilter, flagFilter, order, canGrowCache )

	--Add DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE to the flagFilter
	flagFilter = bit.bor( flagFilter, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE )

	--Do the search
	local result = FindUnitsInRadius( self.team, position, cacheUnit, radius, teamFilter, typeFilter, flagFilter, order, canGrowCache )

	--Wrap result units
	for k, unit in pairs( result ) do
		result[k] = WrapUnit( unit, self.team )
	end

	return result
end

--[[
	AI_EntIndexToHScript( ent_index )
	Return the entity by its entity index.

	Modification: Returns wrapped units/abilities.
	Parameters:
		* ent_index - The entity index of a unit or ability.
]]
function AIWrapper:AI_EntIndexToHScript( ent_index )
	local entity = EntIndexToHScript( ent_index )

	if entity == nil then
		return nil
	else
		--Check if this is a unit or ability
		if entity.GetAbilityName == nil then
			--Unit
			return WrapUnit( entity )
		else
			--Ability
			return WrapAbility( entity )
		end
	end
end

--[[
	AI_MinimapEvent( entity, xCoord, yCoord, eventType, eventDuration )
	Fire an event on the minimap.

	Modification: Removed team parameter, limited to entities in vision.
	Parameters:
		* entity - Entity the event was fired on ( can be nil ).
		* xCoord - The x-coordinate of the event.
		* yCoord - The y-coordinate of the event.
		* eventType - The type of the event, DOTA_MINIMAP_EVENT_*.
		* eventDuration - The duration of the minimap event.
]]
function AIWrapper:AI_MinimapEvent( entity, xCoord, yCoord, eventType, eventDuration )
	--Check if the unit is in vision
	if InVision( entity, self.team ) then
		MinimapEvent( self.team, entity, xCoord, yCoord, eventType, eventDuration )
	else
		--ILL EAGLE
		Warning( string.format( 'AI %i tried to fire minimap event on entity in fog.', self.team ) )
	end
end

--[[
	AI_ExecuteOrderFromTable( ent_index )
	Execute an order from a table

	Modification: Only works for units of the AI, and the target entity is not in fog.
	Parameters:
		* table - The order table, contains the following parameters:
			~ UnitIndex - The entity index of the unit the order is given to.
			~ OrderType - The type of unit given.
			~ TargetIndex - (OPTIONAL) The entity index of the target unit.
			~ AbilityIndex - (OPTIONAL) The entity index of the target unit.
			~ Position - (OPTIONAL) The (vector) position of the order.
			~ Queue - (OPTIONAL) Queue the order or not (boolean).
]]
function AIWrapper:AI_ExecuteOrderFromTable( table )
	--Verify if the unit belongs to the AI
	local unit = EntIndexToHScript( table.UnitIndex )
	if unit:GetTeamNumber() ~= self.team then
		Warning( string.format( 'AI %i tried to execute order on illegal entity.', self.team ) )
		return
	end

	--[[Verity the target is not in fog if it is set
	if table.TargetIndex ~= nil and InVision( EntIndexToHScript( table.TargetIndex ), self.team ) == false then
		Warning( string.format( 'AI %i tried to execute order with illegal target.', self.team ) )
		return
	end]]

	--Execute order
	ExecuteOrderFromTable( table )
end
