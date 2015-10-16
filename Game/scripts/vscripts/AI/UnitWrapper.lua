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
	--If the unit is nil just return
	if unit == nil then return nil end

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
		unit:IsInVision()
		Return if the unit is in vision or not

		Modification:Does not exist in regular API.
		Parameters: -
	]]
	function unit:IsInVision()
		return InVision( globalUnit, team )
	end

	--[[
		unit:HasBuyback()
		Return if the unit has buyback or not. Only for allies.

		Modification:Does not exist in regular API.
		Parameters: -
	]]
	function unit:HasBuyback()
		if globalUnit:GetTeamNumber() == team then
			local gold = globalUnit:GetGold() - globalUnit:GetDeathGoldCost()
			local noScythe = globalUnit:IsBuybackDisabledByReapersScythe() == false
			return ( gold >= globalUnit:GetBuybackCost() and noScythe )
		else
			return false
		end
	end

	--[[
		unit:GetAbsOrigin()
		Get the position of the unit.

		Modification: Return nil when unit is in fog of war.
		Parameters: -
	]]
	function unit:GetAbsOrigin()
		if InVision( globalUnit, team ) then
			return globalUnit:GetAbsOrigin()
		else
			return nil
		end
	end

	--[[
		unit:GetOrigin()
		Get the position of the unit.

		Modification: Return nil when unit is in fog of war.
		Parameters: -
	]]
	function unit:GetOrigin()
		if InVision( globalUnit, team ) then
			return globalUnit:GetOrigin()
		else
			return nil
		end
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

	--[[
		unit:GetHealth()
		Get the health of the unit.

		Modification: Return nil when unit is in fog of war.
		Parameters: -
	]]
	function unit:GetHealth()
		if InVision( globalUnit, team ) then
			return globalUnit:GetHealth()
		else
			return nil
		end
	end

	--[[
		unit:GetMaxHealth()
		Get the maximum health of the unit.

		Modification: Return nil when unit is in fog of war.
		Parameters: -
	]]
	function unit:GetMaxHealth()
		if InVision( globalUnit, team ) then
			return globalUnit:GetMaxHealth()
		else
			return nil
		end
	end

	--[[
		unit:GetModelName()
		Get the model name of the unit.

		Modification: Return nil when unit is in fog of war.
		Parameters: -
	]]
	function unit:GetModelName()
		if InVision( globalUnit, team ) then
			return globalUnit:GetModelName()
		else
			return nil
		end
	end

	--[[
		unit:GetOwner()
		Get the owner of the unit.

		Modification: Wrap result.
		Parameters: -
	]]
	function unit:GetOwner()
		return WrapUnit( globalUnit:GetOwner(), team )
	end

	--[[
		unit:GetOwnerEntity()
		Get the owner of the unit.

		Modification: Wrap result.
		Parameters: -
	]]
	function unit:GetOwnerEntity()
		return WrapUnit( globalUnit:GetOwnerEntity(), team )
	end

	--[[
		unit:GetTeam()
		Get the team of the unit.

		Modification: -
		Parameters: -
	]]
	function unit:GetTeam()
		return globalUnit:GetTeam()
	end

	--[[
		unit:GetTeamNumber()
		Get the team of the unit.

		Modification: -
		Parameters: -
	]]
	function unit:GetTeamNumber()
		return globalUnit:GetTeamNumber()
	end

	--[[
		unit:IsAlive()
		Return if the unit is alive or not.

		Modification: -
		Parameters: -
	]]
	function unit:IsAlive()
		if InVision( globalUnit, team ) then
			return globalUnit:IsAlive()
		else
			return false
		end
	end

	--[[
		unit:GetAbilityByIndex( index )
		Retrieve an ability by index from the unit.
		
		Modification: Wrap the result, only works if unit is in vision, nil otherwise.
		Parameters:
			* index - The index of the ability on the unit
	]]
	function unit:GetAbilityByIndex( index )
		if InVision( globalUnit, team ) then
			return WrapAbility( globalUnit:GetAbilityByIndex( index ), team )
		else
			return nil
		end
	end

	--[[
		unit:FindAbilityByName( name )
		Retrieve an ability by index from the unit.
		
		Modification: Only works if the unit is in vision and wraps result.
		Parameters:
			* name - The name of the ability to look up.
	]]
	function unit:FindAbilityByName( name )
		if InVision( globalUnit, team ) then
			return WrapAbility( globalUnit:FindAbilityByName( name ), team )
		else
			return nil
		end
	end

	--[[
		unit:GetItemInSlot( slot )
		Retrieve an item by slot from the unit.
		
		Modification: Only works if the unit is in vision and wraps the result.
		Parameters:
			* name - The name of the ability to look up.
	]]
	function unit:GetItemInSlot( slot )
		if InVision( globalUnit, team ) then
			return WrapAbility( globalUnit:GetItemInSlot( slot ), team )
		else
			return nil
		end
	end

	--Entity functions
	--==========================================================================

	--[[
		entity:GetClassname()
		Get the classname of the entity.

		Modification: -
		Parameters: -
	]]
	function unit:GetClassname()
		return globalUnit:GetClassname()
	end

	--[[
		entity:GetEntityHandle()
		Get the entity handle of the entity.

		Modification: -
		Parameters: -
	]]
	function unit:GetEntityHandle()
		return globalUnit:GetEntityHandle()
	end

	--[[
		entity:GetEntityIndex()
		Get the entity index of the entity.

		Modification: -
		Parameters: -
	]]
	function unit:GetEntityIndex()
		return globalUnit:GetEntityIndex()
	end

	--[[
		entity:GetName()
		Get the name of the entity.

		Modification: -
		Parameters: -
	]]
	function unit:GetName()
		return globalUnit:GetName()
	end
end