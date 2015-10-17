--[[
	AI Unit tests
	Mainly just to see if all AI functionality is available.

	Code: Perry
	Date: October, 2015
]]
AIUnitTests = class({})

function AIUnitTests:Run( global, unit, ability, aiPlayerRes )

	local success = 0
	local fail = 0

	local globalF = {
		'AI_FindUnitsInRadius',
		'AI_MinimapEvent',
		'AI_EntIndexToHScript',
		'AI_Say',
		'AI_GetGameTime',
		'AI_Log',
		'GetItemCost',
		'LoadKeyValues',
		'RandomFloat',
		'RandomInt',
		'RandomVector',
		'RotateOrientation',
		'RotatePosition',
		'RotateQuaternionByAxisAngle',
		'RotationDelta'
	}

	--Validate global
	for _,func in ipairs( globalF ) do
		if global[func] == nil then
			fail = fail + 1
			Warning('Global function '..func..' not set in AI!')
		else
			success = success + 1
		end
	end

	local unitF = {
		'GetAbsOrigin',
		'GetHealth',
		'GetMaxHealth',
		'GetModelName',
		'GetOrigin',
		'GetOwner',
		'GetOwnerEntity',
		'GetTeam',
		'GetTeamNumber',
		'IsAlive',
		'IsInVision',
		'HasBuyback',
		'GetAbilityByIndex',
		'FindAbilityByName',
		'GetClassname',
		'GetEntityHandle',
		'GetEntityIndex',
		'GetName',
		'GetPlayerOwnerID',
		'GetItemInSlot'
	}

	--Validate unit
	for _,func in ipairs( unitF ) do
		if unit[func] == nil then
			fail = fail + 1
			Warning('Unit function '..func..' not set in AI!')
		else
			success = success + 1
		end
	end

	local abilityF = {
		'GetAbilityDamage',
		'GetAbilityDamageType',
		'GetAbilityTargetFlags',
		'GetAbilityTargetTeam',
		'GetAbilityTargetType',
		'GetAutoCastState',
		'GetBackswingTime',
		'GetCastPoint',
		'GetCooldownTime',
		'GetCooldownTimeRemaining',
		'GetAbilityType',
		'GetAbilityIndex',
		'GetChannelledManaCostPerSecond',
		'GetCooldown',
		'GetClassname',
		'GetEntityHandle',
		'GetEntityIndex',
		'GetName',
		'GetAbilityName'
	}

	--Validate unit
	for _,func in ipairs( abilityF ) do
		if ability[func] == nil then
			fail = fail + 1
			Warning('Ability function '..func..' not set in AI!')
		else
			success = success + 1
		end
	end

	local playerResF = {
		'GetAssists',
		'GetConnectionState',
		'GetDeaths',
		'GetGold',
		'GetKills',
		'GetLastHits',
		'GetDenies',
		'GetLevel',
		'GetNthCourierForTeam',
		'GetNumCouriersForTeam',
		'GetNthPlayerIDOnTeam',
		'GetPlayerCount',
		'GetPlayerCountForTeam',
		'GetPlayerLoadedCompletely',
		'GetPlayerName',
		'GetReliableGold',
		'GetSteamAccountID',
		'GetTeam',
		'GetTeamKills',
		'GetTeamPlayerCount',
		'GetUnreliableGold'
	}

	--Validate AIPlayerResource
	for _,func in ipairs( playerResF ) do
		if aiPlayerRes[func] == nil then
			fail = fail + 1
			Warning('AIPlayerResource function '..func..' not set in AI!')
		else
			success = success + 1
		end
	end

	if fail == 0 then
		print( string.format('AI Unit test: (%i/%i) Success!', success, success ) )
	else
		Warning( string.format('AI Unit test: (%i/%i) Succeeded.\n', success, success + fail ) )
	end

	AIEvents:UnitTest()
end