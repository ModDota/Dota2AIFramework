function DistanceUnitTo( unit, position )
	return (unit:GetAbsOrigin() - position):Length2D()
end

function FindCreeps( position, radius, team, order )
	return AI_FindUnitsInRadius( position, nil, radius, team,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, DOTA_UNIT_TARGET_FLAG_NONE, 
		order, false )
end

function MoveUnitTo( unit, position )
	print( unit, position )
	AI_ExecuteOrderFromTable({
		UnitIndex = unit:GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = position
	})
end

function AggressiveMoveUnitTo( unit, position )
	AI_ExecuteOrderFromTable({
		UnitIndex = unit:GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = position
	})
end

function UnitAttackTarget( unit, target )
	AI_ExecuteOrderFromTable({
		UnitIndex = unit:GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = position
	})
end