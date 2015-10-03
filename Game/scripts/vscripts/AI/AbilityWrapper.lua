--[[
	Ability Wrapper.

	This file contains the wrapper for dota 2 ability entities. A facade is created to
	provide only certain ability functionality to AI. 

	Code: Perry
	Date: October, 2015
]]

--Wrap an ability for a set team
function WrapAbility( ability, team )
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
		Get the remaining cooldown time for the ability.
		
		Modification: Only returns times for abilities of teammates, 0 otherwise.
		Parameters: -
	]]
	function ability:GetCooldownTime()
		if globalAbility:GetCaster():GetTeamNumber() == team then
			return globalAbility:GetCooldownTime()
		else
			return 0
		end
	end
end