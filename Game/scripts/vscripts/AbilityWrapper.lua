--[[
	Ability wrapping functions.
]]

--Wrap an ability for a set team
function WrapAbility( ability, team )
	--Check if we wrapped already
	if ability.wrapped ~= nil then
		return ability.wrapped
	end

	--Wrap the unit
	--Clone first to preserve any data stored on the unit (-should always be wrapped first so redundant?)
	local a = clone( ability )

	--Add functionality to the unit
	AbilitySetup( a, ability, team )

	--Store the wrapped unit
	ability.wrapped = a

	--Return the wrapped unit
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