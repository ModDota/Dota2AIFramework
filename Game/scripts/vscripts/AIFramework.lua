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

	--Make table to store vision dummies in
	AIFramework.visionDummies = {}

	local ai1 = AIFramework:InitAI( 'sample_ai', DOTA_TEAM_GOODGUYS )
end

--Initialise an AI player
function AIFramework:InitAI( name, team )
	--Load an AI
	local ai = AIFramework:LoadAI( name, team )

	--Make a dummy to use for visoin checks
	AIFramework.visionDummies[ team ] = CreateUnitByName( 'npc_dota_thinker', Vector(0,0,0), false, nil, nil, team )
	AIFramework.visionDummies[ team ]:AddNewModifier( nil, nil, 'modifier_dummy', {} ) --Apply the dummy modifier

	--Initialise the loaded AI
	ai:Init( { team = team } )

	return ai
end

--Load a sandboxed AI player
function AIFramework:LoadAI( name, team )
	--Define custom _G
	local global = {}
	global.AIWrapper = AIWrapper( team )
	global.AIEvents = AIEvents( team )

	--Populate global functions
	global = AIFramework:PopulateAIGlobals( global, global.AIWrapper )

	--Load file in sandbox
	return setfenv(assert(loadfile('UserAI.sample_ai')), global)()
end

--Make wrapper functions available globally to the AI
function AIFramework:PopulateAIGlobals( global, wrapper )
	--Lua defaults
	global.math = math
	global.table = table
	global.bit = bit
	global.print = print
	global.pairs = pairs
	global.ipairs = ipairs
	global.type = type

	--Auxiliary includes
	global.DeepPrintTable = DeepPrintTable
	global.Timers = Timers
	global.Vector = Vector

	--Dota global functions
	function global.AI_FindUnitsInRadius ( ... ) return wrapper:AI_FindUnitsInRadius( ... ) end
	function global.AI_EntIndexToHScript ( ... ) return wrapper:AI_EntIndexToHScript( ... ) end

	--Copy over constants
	for k, v in pairs( _G ) do
		if type( v ) == 'string' or type( v ) == 'number' then
			global[k] = v
		end
	end

	return global
end

function clone( obj )
	local new = {}

	for k, v in pairs( obj ) do
		new[k] = v
	end

	return new
end