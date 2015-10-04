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
	--[[
		ability:GetCooldown( level )
		Get the cooldown for a certain level of the ability.
		
		Modification: -
		Parameters:
			* Level - The level to query the cooldown for.
	]]
	function ability:GetCooldown( level )
		return globalAbility:GetCooldown( level )
	end

	--[[
		ability:GetCooldownTime()
		Get the cooldown time for the current level of the ability.
		
		Modification: Only returns times for abilities of teammates, 0 otherwise.
		Parameters: -
	]]
	function ability:GetCooldownTime()
		if OwnedByAlly( globalAbility, team ) then
			return globalAbility:GetCooldownTime()
		else
			return 0
		end
	end

	--[[
		ability:GetCooldownTimeRemaining()
		Get the remaining cooldown time for the ability.
		
		Modification: Only returns times for abilities of teammates, 0 otherwise.
		Parameters: -
	]]
	function ability:GetCooldownTimeRemaining()
		if OwnedByAlly( globalAbility, team ) then
			return globalAbility:GetCooldownTimeRemaining()
		else
			return 0
		end
	end

	--[[
		ability:GetAbilityType()
		Get the type of the ability.
		
		Modification: -
		Parameters: -
	]]
	function ability:GetAbilityType()
		return globalAbility:GetAbilityType()
	end

	--[[
		ability:GetAbilityDamage()
		Get the damage an ability does.
		
		Modification: -
		Parameters: -
	]]
	function ability:GetAbilityDamage()
		return globalAbility:GetAbilityDamage()
	end

	--[[
		ability:GetAbilityDamageType()
		Get the type of damage an ability does.
		
		Modification: -
		Parameters: -
	]]
	function ability:GetAbilityDamageType()
		return globalAbility:GetAbilityDamageType()
	end

	--[[
		ability:GetAbilityTargetFlags()
		Get the target flags of an ability.
		
		Modification: -
		Parameters: -
	]]
	function ability:GetAbilityTargetFlags()
		return globalAbility:GetAbilityTargetFlags()
	end

	--[[
		ability:GetAbilityTargetTeam()
		Get the target team of an ability.
		
		Modification: -
		Parameters: -
	]]
	function ability:GetAbilityTargetTeam()
		return globalAbility:GetAbilityTargetTeam()
	end

	--[[
		ability:GetAbilityTargetType()
		Get the target type of an ability.
		
		Modification: -
		Parameters: -
	]]
	function ability:GetAbilityTargetType()
		return globalAbility:GetAbilityTargetType()
	end

	--[[
		ability:GetAutoCastState()
		Get the auto-cast state (enabled/disabled) of the ability.
		
		Modification: Only works for allied units, false otherwise.
		Parameters: -
	]]
	function ability:GetAutoCastState()
		if OwnedByAlly( ability, team ) then
			return globalAbility:GetAutoCastState()
		else
			return false
		end
	end

	--[[
		ability:GetBackswingTime()
		Get the backswing time of an ability.
		
		Modification: -
		Parameters: -
	]]
	function ability:GetBackswingTime()
		return globalAbility:GetBackswingTime()
	end

	--[[
		ability:GetCastPoint()
		Get the cast point of an ability.
		
		Modification: -
		Parameters: -
	]]
	function ability:GetCastPoint()
		return globalAbility:GetCastPoint()
	end

	--[[
		ability:GetAbilityIndex()
		Get the index of the ability on the unit.
		
		Modification: Only works in vision
		Parameters: -
	]]
	function ability:GetAbilityIndex()
		if InVision( globalAbility:GetCaster(), team ) then
			return globalAbility:GetAbilityIndex()
		else
			return 0
		end
	end

	--[[
		ability:GetChannelledManaCostPerSecond( level )
		Get manacost per second during channel for some level of the ability.
		
		Modification: -
		Parameters: -
	]]
	function ability:GetChannelledManaCostPerSecond( level )
		return globalAbility:GetChannelledManaCostPerSecond( level )
	end

	--Entity functions
	--==========================================================================
	--[[
		entity:GetClassname()
		Get the classname of the entity.

		Modification: -
		Parameters: -
	]]
	function ability:GetClassname()
		return globalUnit:GetClassname()
	end

	--[[
		entity:GetEntityHandle()
		Get the entity handle of the entity.

		Modification: -
		Parameters: -
	]]
	function ability:GetEntityHandle()
		return globalUnit:GetEntityHandle()
	end

	--[[
		entity:GetEntityIndex()
		Get the entity index of the entity.

		Modification: -
		Parameters: -
	]]
	function ability:GetEntityIndex()
		return globalUnit:GetEntityIndex()
	end

	--[[
		entity:GetName()
		Get the name of the entity.

		Modification: -
		Parameters: -
	]]
	function ability:GetName()
		return globalUnit:GetName()
	end
end