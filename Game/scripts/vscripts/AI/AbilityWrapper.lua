--[[
	Ability Wrapper.

	This file contains the wrapper for dota 2 ability entities. A facade is created to
	provide only certain ability functionality to AI. 

	Code: Perry
	Date: October, 2015
]]

--Wrap an ability for a set team
function WrapAbility( ability, team )
	--If the ability is nil just return
	if ability == nil then return nil end

	--Check if we wrapped already
	if ability.wrapped ~= nil then
		return ability.wrapped
	end

	--Create facade ability
	local a = {}

	--Add functionality to the ability
	AbilitySetup( a, ability, team )

	--Store the wrapped ability
	ability.wrapped = a

	--Return the wrapped ability
	return a
end

local function OwnedByAlly( ability, team )
	return ability:GetCaster():GetTeamNumber() == team
end

--====================================================================================================
-- Define Ability functionality
--====================================================================================================
function AbilitySetup( ability, globalAbility, team )
	--[[[
		@func ability:GetCooldown( level )
		@desc Get the cooldown for a certain level of the ability.
		
		@modification -
		@param {integer} Level The level to query the cooldown for.
	]]
	function ability:GetCooldown( level )
		return globalAbility:GetCooldown( level )
	end

	--[[[
		@func ability:GetCooldownTime()
		@desc Get the cooldown time for the current level of the ability.
		
		@modification Only returns times for abilities of teammates, 0 otherwise.
	]]
	function ability:GetCooldownTime()
		if OwnedByAlly( globalAbility, team ) then
			return globalAbility:GetCooldownTime()
		else
			return 0
		end
	end

	--[[[
		@func ability:GetCooldownTimeRemaining()
		@desc Get the remaining cooldown time for the ability.
		
		@modification Only returns times for abilities of teammates, 0 otherwise.
	]]
	function ability:GetCooldownTimeRemaining()
		if OwnedByAlly( globalAbility, team ) then
			return globalAbility:GetCooldownTimeRemaining()
		else
			return 0
		end
	end

	--[[[
		@func ability:GetAbilityName()
		@desc Get the name of the ability.
		
		@modification -
	]]
	function ability:GetAbilityName()
		return globalAbility:GetAbilityName()
	end

	--[[[
		@func ability:GetAbilityType()
		@desc Get the type of the ability.
		
		@modification -
	]]
	function ability:GetAbilityType()
		return globalAbility:GetAbilityType()
	end

	--[[[
		@func ability:GetAbilityDamage()
		@desc Get the damage an ability does.
		
		@modification -
	]]
	function ability:GetAbilityDamage()
		return globalAbility:GetAbilityDamage()
	end

	--[[[
		@func ability:GetAbilityDamageType()
		@desc Get the type of damage an ability does.
		
		@modification -
	]]
	function ability:GetAbilityDamageType()
		return globalAbility:GetAbilityDamageType()
	end

	--[[[
		@func ability:GetAbilityTargetFlags()
		@desc Get the target flags of an ability.
		
		@modification -
	]]
	function ability:GetAbilityTargetFlags()
		return globalAbility:GetAbilityTargetFlags()
	end

	--[[[
		@func ability:GetAbilityTargetTeam()
		@desc Get the target team of an ability.
		
		@modification -
	]]
	function ability:GetAbilityTargetTeam()
		return globalAbility:GetAbilityTargetTeam()
	end

	--[[[
		@func ability:GetAbilityTargetType()
		@desc Get the target type of an ability.
		
		@modification -
	]]
	function ability:GetAbilityTargetType()
		return globalAbility:GetAbilityTargetType()
	end

	--[[[
		@func ability:GetAutoCastState()
		@desc Get the auto-cast state (enabled/disabled) of the ability.
		
		@modification Only works for allied units, false otherwise.
	]]
	function ability:GetAutoCastState()
		if OwnedByAlly( ability, team ) then
			return globalAbility:GetAutoCastState()
		else
			return false
		end
	end

	--[[[
		@func ability:GetBackswingTime()
		@desc Get the backswing time of an ability.
		
		@modification -
	]]
	function ability:GetBackswingTime()
		return globalAbility:GetBackswingTime()
	end

	--[[[
		@func ability:GetCastPoint()
		@desc Get the cast point of an ability.
		
		@modification -
	]]
	function ability:GetCastPoint()
		return globalAbility:GetCastPoint()
	end

	--[[[
		@func ability:GetAbilityIndex()
		@desc Get the index of the ability on the unit.
		
		@modification Only works in vision
	]]
	function ability:GetAbilityIndex()
		if InVision( globalAbility:GetCaster(), team ) then
			return globalAbility:GetAbilityIndex()
		else
			return 0
		end
	end

	--[[[
		@func ability:GetChannelledManaCostPerSecond( level )
		@desc Get manacost per second during channel for some level of the ability.
		
		@modification -
	]]
	function ability:GetChannelledManaCostPerSecond( level )
		return globalAbility:GetChannelledManaCostPerSecond( level )
	end

	--[[[
		@func ability:IsItem()
		@desc Return if the ability is an item or not.

		@modification -
	]]
	function ability:IsItem()
		return globalAbility:IsItem()
	end

	--[[[
		@func ability:GetCurrentCharges()
		@desc Get the current amount of charges on an item.

		@modification Only works if the owner is in vision.
	]]
	function ability:GetCurrentCharges()
		if InVision( globalAbility:GetCaster(), team ) then
			return globalAbility:GetCurrentCharges()
		else
			return 0
		end
	end

	--Entity functions
	--==========================================================================
	--[[[
		@func entity:GetClassname()
		@desc Get the classname of the entity.

		@modification -
	]]
	function ability:GetClassname()
		return globalAbility:GetClassname()
	end

	--[[[
		@func entity:GetEntityHandle()
		@desc Get the entity handle of the entity.

		@modification -
	]]
	function ability:GetEntityHandle()
		return globalAbility:GetEntityHandle()
	end

	--[[[
		@func entity:GetEntityIndex()
		@desc Get the entity index of the entity.

		@modification -
	]]
	function ability:GetEntityIndex()
		return globalAbility:GetEntityIndex()
	end

	--[[[
		@func entity:GetName()
		@desc Get the name of the entity.

		@modification -
	]]
	function ability:GetName()
		return globalAbility:GetName()
	end
end