--[[
	Some fancy comment block.
]]

--Class definition
if AIFramework == nil then
	AIFramework = class({})
end

--Initialisation
function AIFramework:Init()
	print( 'Initialising AI framework.' )

	--Define AI parameters
	local aiParams = {
		a = 3,
		b = 6
	}

	local ai1 = AIFramework:InitAI( 'sample_ai', DOTA_TEAM_GOODGUYS )
end

--Initialise an AI player
function AIFramework:InitAI( name, team )
	--Load an AI
	local ai = AIFramework:LoadAI( name, team )

	--Initialise the loaded AI
	ai:Init( aiParams )

	return ai
end

--Load a sandboxed AI player
function AIFramework:LoadAI( name, team )
	--Define custom _G
	local global = clone( _G )
	global.AIWrapper = AIWrapper( team )

	local newEnt = clone(_G.CBaseEntity)
	newEnt.SetAbsOrigin = function( self )
		print('ILL EAGLE')
	end

	global.CBaseEntity = newEnt

	--Load file in sandbox
	return setfenv(assert(loadfile('UserAI.sample_ai')), global)()
end

function clone( obj )
	local new = {}

	for k, v in pairs( obj ) do
		new[k] = v
	end

	return new
end