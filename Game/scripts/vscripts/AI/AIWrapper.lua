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

--Keep some colors to use for each team
local teamColor = {
	[2] = { hex="#3375FF", vec=Vector(51,117,255) },
	[4] = { hex="#66FFBF", vec=Vector(102,255,191) },
	[6] = { hex="#BF00BF", vec=Vector(191,0,191) },
	[8] = { hex="#F3F00B", vec=Vector(243,240,11) },
	[10] = { hex="#FF6B00", vec=Vector(255,107,0) },
	[3] = { hex="#FE86C2", vec=Vector(254,134,194) },
	[5] = { hex="#A1B447", vec=Vector(161,180,71) },
	[7] = { hex="#65D9F7", vec=Vector(101,217,247) },
	[9] = { hex="#008321", vec=Vector(0,131,33) },
	[11] = { hex="#A46900", vec=Vector(164,105,0) }
}

--Constructor
function AIWrapper:constructor( team )
	self.team = team
end

--=======================================================================================================================
--AI-accessible functions
--=======================================================================================================================

--[[[
	@func AI_FindUnitsInRadius( position, radius, teamFilter, typeFilter, flagFilter, order, canGrowCache )
	@desc Finds units in a radius with some parameters.

	@modification Can only find units visible by the AI's team.
	@param {Vector} Position The center of the circle to search in
	@param {integer} Radius The radius to search in
	@param {integer} TeamFilter DOTA_UNIT_TARGET_TEAM_* filter.
	@param {integer} TypeFilter DOTA_UNIT_TARGET_TYPE_* filter.
	@param {integer} FlagFilter DOTA_UNIT_TARGET_FLAG_* filter.
	@param {integer} Order The order to return results in.
	@param {boolean} CanGrowCache Can the search grow the cache.
]]
function AIWrapper:AI_FindUnitsInRadius( position, radius, teamFilter, typeFilter, flagFilter, order, canGrowCache )

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

--[[[
	@func AI_EntIndexToHScript( ent_index )
	@desc Return the entity by its entity index.

	@modification Returns wrapped units/abilities.
	@param {integer} ent_index The entity index of a unit or ability.
]]
function AIWrapper:AI_EntIndexToHScript( ent_index )
	local entity = EntIndexToHScript( ent_index )

	if entity == nil then
		return nil
	else
		--Check if this is a unit or ability
		if entity.GetAbilityName == nil then
			--Unit
			return WrapUnit( entity, self.team )
		else
			--Ability
			return WrapAbility( entity )
		end
	end
end

--[[[
	@func AI_MinimapEvent( entity, xCoord, yCoord, eventType, eventDuration )
	@desc Fire an event on the minimap.

	@modification Removed team parameter, limited to entities in vision.
	@param {handle} entity Entity the event was fired on ( can be nil ).
	@param {float} xCoord The x-coordinate of the event.
	@param {float} yCoord The y-coordinate of the event.
	@param {integer} eventType The type of the event, DOTA_MINIMAP_EVENT_*.
	@param {float} eventDuration The duration of the minimap event.
]]
function AIWrapper:AI_MinimapEvent( entity, xCoord, yCoord, eventType, eventDuration )
	--Check if the unit is in vision
	if InVision( entity, self.team ) then
		MinimapEvent( self.team, entity, xCoord, yCoord, eventType, eventDuration )
	else
		--ILL EAGLE
		Warning( string.format( 'AI %i tried to fire minimap event on entity in fog.\n', self.team ) )
	end
end

--[[[
	@func AI_ExecuteOrderFromTable( ent_index )
	@desc Execute an order from a table

	@modification Only works for units of the AI, and the target entity is not in fog.
	@param {table} table The order table, contains the following parameters:
			* UnitIndex - The entity index of the unit the order is given to.
			* OrderType - The type of unit given.
			* TargetIndex - (OPTIONAL) The entity index of the target unit.
			* AbilityIndex - (OPTIONAL) The entity index of the target unit.
			* Position - (OPTIONAL) The (vector) position of the order.
			* Queue - (OPTIONAL) Queue the order or not (boolean).
]]
function AIWrapper:AI_ExecuteOrderFromTable( table )
	--Verify if the unit belongs to the AI
	local unit = EntIndexToHScript( table.UnitIndex )
	if unit:GetTeamNumber() ~= self.team then
		Warning( string.format( 'AI %i tried to execute order on illegal entity.\n', self.team ) )
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

--[[[
	@func AI_Say( player, message, teamOnly )
	@desc Make a player say something in chat.

	@modification Only works for players owned by the AI, uses player ID instead of player.
	@param {integer} playerID The id of the player doing the talking.
	@param {string} message The message.
	@param {boolean} teamOnly Is the message in team chat or not (boolean).
]]
function AIWrapper:AI_Say( playerID, message, teamOnly )
	local player = PlayerResource:GetPlayer( playerID )
	local team = PlayerResource:GetTeam( playerID )

	if team == self.team then
		Say( player, message, teamOnly )
	else
		Warning( string.format( 'AI %i tried to AI_Say for another team.\n', self.team ) )
	end
end

--[[[
	@func AI_BuyItem( unit, itemName )
	@desc Buy an item on a unit.

	@modification Does not exist in the original AI.
	@param {handle} unit The unit to buy the item on.
	@param {string} itemName The item to buy.
]]
function AIWrapper:AI_BuyItem( unit, itemName )
	local orgUnit = EntIndexToHScript( unit:GetEntityIndex() )
	local cost = GetItemCost( itemName )

	-- Check if unit is in shop trigger
	local inTrigger = false
	local unitPos = orgUnit:GetAbsOrigin()
	for _, trigger in pairs( Entities:FindAllByClassname( 'trigger_shop' ) ) do
		local maxs = trigger:GetBoundingMaxs() + trigger:GetAbsOrigin()
		local mins = trigger:GetBoundingMins() + trigger:GetAbsOrigin()

		if unitPos.x >= mins.x and unitPos.y >= mins.y and unitPos.x <= maxs.x and unitPos.y <= maxs.y then
			inTrigger = true
			break
		end
	end
	print(inTrigger)

	if inTrigger then
		local hasSpace = false
		for i=0,11 do
			local item = orgUnit:GetItemInSlot( i )
			if item == nil then
				hasSpace = true
				break
			end
		end

		if orgUnit:GetGold() >= cost and hasSpace then
			orgUnit:ModifyGold( -cost, false, DOTA_ModifyGold_PurchaseItem )
			local item = CreateItem( itemName, orgUnit, orgUnit )
			orgUnit:AddItem( item )
		end
	end
end

--[[[
	@func AI_GetGameTime()
	@desc Get the current game time.

	@modification -
]]
function AIWrapper:AI_GetGameTime()
	return GameRules:GetGameTime()
end

--[[[
	@func AI_Log( message )
	@desc Log functionality for AI.

	@modification -
	@param {string} message The message to log
]]
function AIWrapper:AI_Log( message )
	local time = GameRules:GetGameTime()
	if AIManager.AllowInGameLogging then
		GameRules:SendCustomMessage( string.format( '<font color="%s">[AI %i | %.2f]: %s</font>', teamColor[ self.team ].hex, self.team, time, message ), -1, 0 )
	end
	print( string.format( '[AI %i | %.2f]: %s', self.team, time, message ) )
end

--[[[
	@func AI_DebugDrawBox( origin, min, max, r, g, b, a, duration )
	@desc Draw a box.

	@modification Only works if AIManager.AllowDebugDrawing. Forces a certain color if AIManager.ForceDrawColor.
	@param {Vector} origin The origin vector.
	@param {Vector} min A vector relative to the origin with the minimal coordinate corner.
	@param {Vector} max A vector relative to the origin with the maximal coordinate corner.
	@param {integer} r The red component in the RGBA color (0-255).
	@param {integer} g The green component in the RGBA color (0-255).
	@param {integer} b The blue component in the RGBA color (0-255).
	@param {integer} a The alpha component in the RGBA color (0-255).
	@param {float} duration The duration of the drawing in seconds.
]]
function AIWrapper:DebugDrawBox( origin, min, max, r, g, b, a, duration )
	if AIManager.AllowDebugDrawing then
		if AIManager.ForceDrawColor then
			r = teamColor[ self.team ].vec.x
			g = teamColor[ self.team ].vec.y
			b = teamColor[ self.team ].vec.z
		end
		DebugDrawBox( origin, min, max, r, g, b, a, math.min( duration, 5 ) )
	end
end

--[[[
	@func AI_DebugDrawCircle( center, vRgb, a, rad, ztest, duration )
	@desc Draw a circle.

	@modification Only works if AIManager.AllowDebugDrawing. Forces a certain color if AIManager.ForceDrawColor.
	@param {Vector} center The center of the circle
	@param {Vector} vRgba The color vector for the circle
	@param {integer} a The alpha channel of the color.
	@param {integer} rad The radius of the circle.
	@param {boolean} ztest Disable ztest?
	@param {float} duration The duration of the drawing
]]
function AIWrapper:DebugDrawCircle( center, vRgb, a, rad, ztest, duration )
	if AIManager.AllowDebugDrawing then
		if AIManager.ForceDrawColor then
			vRgb = teamColor[ self.team ].vec
		end
		DebugDrawCircle( center, vRgb, a, rad, ztest, math.min( duration, 5 ) )
	end
end

--[[[
	@func AI_DebugDrawSphere( center, vRgb, a, rad, ztest, duration )
	@desc Draw a sphere.

	@modification Only works if AIManager.AllowDebugDrawing. Forces a certain color if AIManager.ForceDrawColor.
	@param {Vector} center The center of the circle
	@param {Vector} vRgba The color vector for the circle
	@param {integer} a The alpha channel of the color.
	@param {integer} rad The radius of the circle.
	@param {boolean} ztest Disable ztest?
	@param {float} duration The duration of the drawing
]]
function AIWrapper:DebugDrawSphere( center, vRgb, a, rad, ztest, duration )
	if AIManager.AllowDebugDrawing then
		if AIManager.ForceDrawColor then
			vRgb = teamColor[ self.team ].vec
		end
		DebugDrawSphere( center, vRgb, a, rad, ztest, math.min( duration, 5 ) )
	end
end

--[[[
	@func AI_DebugDrawLine( origin, target, r, g, b, ztest, duration )
	@desc Draw a line.

	@modification Only works if AIManager.AllowDebugDrawing. Forces a certain color if AIManager.ForceDrawColor.
	@param {Vector} origin The origin vector (from).
	@param {Vector} target The target vector (to).
	@param {integer} r The red component in the RGBA color (0-255).
	@param {integer} g The green component in the RGBA color (0-255).
	@param {integer} b The blue component in the RGBA color (0-255).
	@param {boolean} ztest Disable ztest?
	@param {float} duration The duration of the drawing in seconds.
]]
function AIWrapper:DebugDrawLine( origin, target, r, g, b, ztest, duration )
	if AIManager.AllowDebugDrawing then
		if AIManager.ForceDrawColor then
			r = teamColor[ self.team ].vec.x
			g = teamColor[ self.team ].vec.y
			b = teamColor[ self.team ].vec.z
		end
		DebugDrawLine( origin, target, r, g, b, ztest, math.min( duration, 5 ) )
	end
end

--[[[
	@func AI_DebugDrawText( origin, text, viewCheck, duration )
	@desc Draw text.

	@modification Only works if AIManager.AllowDebugDrawing. Forces a certain color if AIManager.ForceDrawColor.
	@param {Vector} origin The origin vector (from).
	@param {string} text The text to display.
	@param {boolean} viewCheck Is the text aligned with the viewport?
	@param {float} duration The duration of the drawing in seconds.
]]
function AIWrapper:DebugDrawText( origin, text, viewCheck, duration )
	if AIManager.AllowDebugDrawing then
		DebugDrawText( origin, text, viewCheck, math.min( duration, 5 ) )
	end
end
