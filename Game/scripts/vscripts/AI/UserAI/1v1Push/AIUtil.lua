function DistanceUnitTo( unit, position )
	return (unit:GetAbsOrigin() - position):Length2D()
end

function FindCreeps( position, radius, team, order )
	return AI_FindUnitsInRadius( position, radius, team,
		DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 
		order, false )
end

function FindTargets( position, radius, team, order )
	return AI_FindUnitsInRadius( position, radius, team,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 
		order, false )
end

function MoveUnitTo( unit, position, queue )
	if queue == nil then queue = false end
	AI_ExecuteOrderFromTable({
		UnitIndex = unit:GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = position,
		Queue = queue
	})
end

function AggressiveMoveUnitTo( unit, position, queue )
	if queue == nil then queue = false end
	AI_ExecuteOrderFromTable({
		UnitIndex = unit:GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = position,
		Queue = queue
	})
end

function UnitAttackTarget( unit, target, queue )
	if queue == nil then queue = false end
	AI_ExecuteOrderFromTable({
		UnitIndex = unit:GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = target:GetEntityIndex(),
		Queue = queue
	})
end

function UnitLevelUpAbility( unit, ability, queue )
	if queue == nil then queue = false end
	AI_ExecuteOrderFromTable({
		UnitIndex = unit:GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_TRAIN_ABILITY,
		AbilityIndex = ability:GetEntityIndex(),
		Queue = queue
	})
end

function CastNoTarget( unit, ability, queue )
	if queue == nil then queue = false end
	AI_ExecuteOrderFromTable({
		UnitIndex = unit:GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = ability:GetEntityIndex(),
		Queue = queue
	})
end

function AverageUnitPos( units )
	local n = 0
	local pos = Vector( 0, 0, 0 )

	for _,unit in pairs( units ) do
		pos = pos + unit:GetAbsOrigin()
		n = n + 1
	end

	if n > 1 then pos = pos * (1/n) end

	return pos
end

function FindItemByName( unit, itemName )
	local item = nil
	for i=0,5 do
		local slot = unit:GetItemInSlot( i )
		if slot ~= nil and slot:GetAbilityName() == itemName then
			item = slot
			break
		end
	end
	return item
end

function UnitBuyItem( unit, itemName )
	AI_BuyItem( unit, itemName )
end

function TryAndReport( f, context )
	local status, error = pcall( f, context )
	if status == false then
		print( error )
		print( debug.traceback() )
	end
end
