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

	--[[[
		@func unit:IsInVision()
		@desc Return if the unit is in vision or not

		@modification Does not exist in regular API.
	]]
	function unit:IsInVision()
		return InVision( globalUnit, team )
	end

	--[[[
		@func unit:HasBuyback()
		@desc Return if the unit has buyback or not. Only for allies.

		@modification Does not exist in regular API.
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

	--[[[
		@func unit:GetAbsOrigin()
		@desc Get the position of the unit.

		@modification Return nil when unit is in fog of war.
	]]
	function unit:GetAbsOrigin()
		if InVision( globalUnit, team ) then
			return globalUnit:GetAbsOrigin()
		else
			return nil
		end
	end

	--[[[
		@func unit:GetOrigin()
		@desc Get the position of the unit.

		@modification Return nil when unit is in fog of war.
	]]
	function unit:GetOrigin()
		if InVision( globalUnit, team ) then
			return globalUnit:GetOrigin()
		else
			return nil
		end
	end

	--[[[
		@func unit:GetPlayerOwnerID()
		@desc Get the ID of the player owning this unit.

		@modification -
	]]
	function unit:GetPlayerOwnerID()
		return globalUnit:GetPlayerOwnerID()
	end

	--[[[
		@func unit:GetHealth()
		@desc Get the health of the unit.

		@modification Return nil when unit is in fog of war.
	]]
	function unit:GetHealth()
		if InVision( globalUnit, team ) then
			return globalUnit:GetHealth()
		else
			return nil
		end
	end

	--[[[
		@func unit:GetMaxHealth()
		@desc Get the maximum health of the unit.

		@modification Return nil when unit is in fog of war.
	]]
	function unit:GetMaxHealth()
		if InVision( globalUnit, team ) then
			return globalUnit:GetMaxHealth()
		else
			return nil
		end
	end

	--[[[
		@func unit:GetModelName()
		@desc Get the model name of the unit.

		@modification Return nil when unit is in fog of war.
	]]
	function unit:GetModelName()
		if InVision( globalUnit, team ) then
			return globalUnit:GetModelName()
		else
			return nil
		end
	end

	--[[[
		@func unit:GetOwner()
		@desc Get the owner of the unit.

		@modification Wrap result.
	]]
	function unit:GetOwner()
		return WrapUnit( globalUnit:GetOwner(), team )
	end

	--[[[
		@func unit:GetOwnerEntity()
		@desc Get the owner of the unit.

		@modification Wrap result.
	]]
	function unit:GetOwnerEntity()
		return WrapUnit( globalUnit:GetOwnerEntity(), team )
	end

	--[[[
		@func unit:GetTeam()
		@desc Get the team of the unit.

		@modification -
	]]
	function unit:GetTeam()
		return globalUnit:GetTeam()
	end

	--[[[
		@func unit:GetTeamNumber()
		@desc Get the team of the unit.

		@modification None.
	]]
	function unit:GetTeamNumber()
		return globalUnit:GetTeamNumber()
	end

	--[[[
		@func unit:IsAlive()
		@desc Return if the unit is alive or not.

		@modification -
	]]
	function unit:IsAlive()
		if InVision( globalUnit, team ) then
			return globalUnit:IsAlive()
		else
			return false
		end
	end

	--[[[
		@func unit:GetAbilityByIndex( index )
		@desc Retrieve an ability by index from the unit.
		
		@modification Wrap the result, only works if unit is in vision, nil otherwise.
		@param {number} index The index of the ability on the unit.
	]]
	function unit:GetAbilityByIndex( index )
		if InVision( globalUnit, team ) then
			return WrapAbility( globalUnit:GetAbilityByIndex( index ), team )
		else
			return nil
		end
	end

	--[[[
		@func unit:FindAbilityByName( name )
		@desc Retrieve an ability by index from the unit.
		
		@modification Only works if the unit is in vision and wraps result.
		@param {string} name The name of the ability to look up.
	]]
	function unit:FindAbilityByName( name )
		if InVision( globalUnit, team ) then
			return WrapAbility( globalUnit:FindAbilityByName( name ), team )
		else
			return nil
		end
	end

	--[[[
		@func unit:GetItemInSlot( slot )
		@desc Retrieve an item by slot from the unit.
		
		@modification Only works if the unit is in vision and wraps the result.
		@param {number} slot The name of the ability to look up.
	]]
	function unit:GetItemInSlot( slot )
		if InVision( globalUnit, team ) then
			return WrapAbility( globalUnit:GetItemInSlot( slot ), team )
		else
			return nil
		end
	end

	--[[[
		@func unit:GetAbilityPoints()
		@desc Retrieve the amount of ability points a hero has.
		
		@modification Only works for allies.
	]]
	function unit:GetAbilityPoints()
		if globalUnit:GetTeamNumber() == team and globalUnit.GetAbilityPoints ~= nil then
			return globalUnit:GetAbilityPoints()
		else
			return 0
		end
	end

	--[[[
		@func unit:GetLevel()
		@desc Get the level of a unit.
		
		@modification Modification: Only works for units in vision.
	]]
	function unit:GetLevel()
		if InVision( globalUnit, team ) then
			return globalUnit:GetLevel()
		else
			return 0
		end
	end

	--[[[
		@func unit:GetGold()
		@desc Get the gold of a unit.
		
		@modification Modification: Only works for allies.
	]]
	function unit:GetGold()
		if globalUnit:GetTeamNumber() == team then
			return globalUnit:GetGold()
		else
			return 0
		end
	end

	--[[[
		@func unit:IsHero()
		@desc See if the hero is a unit or not.

		@modification Only works in vision.
	]]
	function unit:IsHero()
		if InVision( globalUnit, team ) then
			return globalUnit:IsHero()
		else
			return false
		end
	end

	--[[[
		@func unit:IsTower()
		@desc See if the hero is a unit or not.

		@modification Only works in vision.
	]]
	function unit:IsTower()
		if InVision( globalUnit, team ) then
			return globalUnit:IsTower()
		else
			return false
		end
	end

	--[[[
		@func unit:GetForwardVector()
		@desc Get the forward vector of the unit.

		@modification Only works in vision.
	]]
	function unit:GetForwardVector()
		if InVision( globalUnit, team ) then
			return globalUnit:GetForwardVector()
		else
			return Vector( 1, 0, 0 )
		end
	end

	--[[[
		@func unit:GetAttackRange()
		@desc Get the unit's attack range.

		@modification: Only works in vision.
	]]
	function unit:GetAttackRange()
		if InVision( globalUnit, team ) then
			return globalUnit:GetAttackRange()
		else
			return 0
		end
	end

	--[[[
		@func unit:GetAttackAnimationPoint()
		@desc Get the unit's attack animation point.

		@modification: Only works in vision.
	]]
	function unit:GetAttackRange()
		if InVision( globalUnit, team ) then
			return globalUnit:GetAttackAnimationPoint()
		else
			return 0
		end
	end

	--[[[
		@func unit:GetAttackCapability()
		@desc Get the unit's attack capability.

		@modification: Only works in vision.
	]]
	function unit:GetAttackCapability()
		if InVision( globalUnit, team ) then
			return globalUnit:GetAttackCapability()
		else
			return 0
		end
	end

	--[[[
		@func unit:GetAttackRange()
		@desc Get the unit's attack range.

		@modification: Only works in vision.
	]]
	function unit:GetAttackRange()
		if InVision( globalUnit, team ) then
			return globalUnit:GetForwardVector()
		else
			return 0
		end
	end

	--[[[
		@func unit:GetAttackSpeed()
		@desc Get the unit's attack speed.

		@modification: Only works in vision.
	]]
	function unit:GetAttackSpeed()
		if InVision( globalUnit, team ) then
			return globalUnit:GetAttackSpeed()
		else
			return 0
		end
	end

	--[[[
		@func unit:GetAttacksPerSecond()
		@desc Get the amount of attacks the unit does per second based on its attack speed.

		@modification: Only works in vision.
	]]
	function unit:GetAttacksPerSecond()
		if InVision( globalUnit, team ) then
			return globalUnit:GetAttacksPerSecond()
		else
			return 0
		end
	end

	--[[[
		@func unit:GetIdealSpeed()
		@desc Get the unit's movespeed.

		@modification: Only works in vision.
	]]
	function unit:GetIdealSpeed()
		if InVision( globalUnit, team ) then
			return globalUnit:GetIdealSpeed()
		else
			return 0
		end
	end

	--[[[
		@func unit:GetProjectileSpeed()
		@desc Get the unit's projectile speed.

		@modification: Only works in vision.
	]]
	function unit:GetProjectileSpeed()
		if InVision( globalUnit, team ) then
			return globalUnit:GetProjectileSpeed()
		else
			return 0
		end
	end

	--[[[
		@func unit:GetAverageTrueDamage()
		@desc Get the average value of the unit's minimum and maximum damage values.

		@modification: Only works in vision.
	]]
	function unit:GetAverageTrueDamage()
		if InVision( globalUnit, team ) then
			return globalUnit:GetForwardVector()
		else
			return 0
		end
	end

	--[[[
		@func unit:GetUnitName()
		@desc Get the name of the unit.

		@modification -
	]]
	function unit:GetUnitName()
		return globalUnit:GetUnitName()
	end

	--Entity functions
	--==========================================================================

	--[[[
		@func entity:GetClassname()
		@desc Get the classname of the entity.

		@modification -
	]]
	function unit:GetClassname()
		return globalUnit:GetClassname()
	end

	--[[[
		@func entity:GetEntityHandle()
		@desc Get the entity handle of the entity.

		@modification -
	]]
	function unit:GetEntityHandle()
		return globalUnit:GetEntityHandle()
	end

	--[[[
		@func entity:GetEntityIndex()
		@desc Get the entity index of the entity.

		@modification -
	]]
	function unit:GetEntityIndex()
		return globalUnit:GetEntityIndex()
	end

	--[[[
		@func entity:GetName()
		@desc Get the name of the entity.

		@modification -
	]]
	function unit:GetName()
		return globalUnit:GetName()
	end
end