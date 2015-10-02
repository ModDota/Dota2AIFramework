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

	local ai1 = AIFramework:InitAI( 'sample_ai', 42 )
	local ai2 = AIFramework:InitAI( 'sample_ai', 1 )
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
	local global = { 
		print = _G.print,
		DeepPrintTable = _G.DeepPrintTable,
		AIWrapper = AIWrapper( team )
	}

	--Load file in sandbox
	return setfenv(loadfile('UserAI.sample_ai'), global)()
end