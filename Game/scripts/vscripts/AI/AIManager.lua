--[[
	AI Manager.

	Highest level AI module, used for setting up AI in the game.

	Code: Perry
	Date: October, 2015
]]

require( 'AI.AIWrapper' )
require( 'AI.AIEvents' )
require( 'AI.AIPlayerResource' )
require( 'AI.UnitWrapper' )
require( 'AI.AbilityWrapper' )
require( 'AI.AIUnitTests' )

if AIManager == nil then
	AIManager = class({})
else
	AIManager:OnScriptReload()
end

--Initialise the AIManager
function AIManager:Init()
	ListenToGameEvent( 'dota_player_pick_hero', AIManager.OnPlayerConnect, self )
	ListenToGameEvent( 'game_rules_state_change', AIManager.OnGameStateChange, self )

	AIManager.visionDummies = {}
	AIManager.numPlayers = 0

	AIManager.aiHandles = {}
	AIManager.aiNames = {}

	AIManager.playerRequests = {}
	AIManager.aiPlayers = {}
	AIManager.aiHeroes = {}

	AIManager.heroesToSpawn = 0
	AIManager.heroesSpawned = 0

	AIManager:PopulateItemTable()

	AIManager.AllowInGameLogging = true
	AIManager.AllowDebugDrawing = true
	AIManager.ForceDrawColor = true

	--Update the settings when an event from the client is received
	CustomGameEventManager:RegisterListener( 'spectator_options_update', function( player, event )
		AIManager.AllowInGameLogging = event.allowLog == 1
		if event.allowDraw == 0 and AIManager.AllowDebugDrawing == 1 then
			DebugDrawClear()
		end
		AIManager.AllowDebugDrawing = event.allowDraw == 1
		AIManager.ForceDrawColor = event.forceColor == 1
	end)
end

--Fetch a table of item and custom items
function AIManager:PopulateItemTable()
	AIManager.itemTable = LoadKeyValues( 'scripts/npc/items.txt' )
	local customItems = LoadKeyValues( 'scripts/npc/items_custom.txt' )
	if customItems ~= nil then
		for itemName, item in pairs( customItems ) do
			AIManager.itemTable[ itemName ] = item
		end
	end
end

--script_reload handling
function AIManager:OnScriptReload()
	--Reload AI functions
	for team, ai in pairs( AIManager.aiHandles ) do
		local newAI = AIManager:LoadAI( AIManager.aiNames[ team ], team )
		for k,v in pairs( newAI ) do
			if type(v) == 'function' then
				ai[k] = v
			end
		end
	end
end

--A player has connected, if it's a fake client assign it to an AI that wants a player
function AIManager:OnPlayerConnect( event )
	--Only bots pick heroes in setup
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		--Handle player request
		local request = table.remove( AIManager.playerRequests, 1 )

		if request ~= nil then
			local hero = EntIndexToHScript( event.heroindex )
			local pID = hero:GetPlayerOwnerID()

			-- Set team
			PlayerResource:SetCustomTeamAssignment( pID, request.team )

			--Remember we have to spawn a hero for this player
			AIManager.heroesToSpawn = AIManager.heroesToSpawn + 1

			if AIManager.aiPlayers[ request.team ] == nil then 
				AIManager.aiPlayers[ request.team ] = {} 

				--Initialise array for heroes for this team too while we're at it
				AIManager.aiHeroes[ request.team ] = {} 
			end

			table.insert( AIManager.aiPlayers[ request.team ], { pID = pID, hero = request.hero } )
		end
	end
end

--Game state change handler
function AIManager:OnGameStateChange( event )
	local gameState = GameRules:State_Get()

	if gameState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		--In hero selection, spawn the heroes for all AIs
		for team, players in pairs( AIManager.aiPlayers ) do
			for _,player in pairs( players ) do
				--Precache the hero
				PrecacheUnitByNameAsync( player.hero, function()
					AIManager:PrecacheDone( player.pID, player.hero, team )
				end, player.pID )
			end
		end
	end
end

--The precache of a hero is done, spawn the hero for the player
function AIManager:PrecacheDone( pID, heroName, team )
	--Spawn the hero
	local player = PlayerResource:GetPlayer( pID )
	local hero = PlayerResource:ReplaceHeroWith( pID, heroName, 0, 0 )
	hero:RespawnHero(false, true, false)

	table.insert( AIManager.aiHeroes[ team ], hero )
end

--Initialise all AI
function AIManager:InitAllAI( gameMode )
	--Initialise all AI
	print('Initialising AI')
	for team, ai in pairs( AIManager.aiHandles ) do
		--Wrap heroes
		local wrappedHeroes = {}
		for _, hero in pairs( AIManager.aiHeroes[ team ] ) do
			table.insert( wrappedHeroes, WrapUnit( hero, team ) )
		end

		--Initialise AI
		ai:Init( { team = team, heroes = wrappedHeroes, data = gameMode:GetExtraData( team ) } )
	end
end

--Attach AI to an existing unit
function AIManager:AttachAI( aiName, unit )
	--Load the ai
	local team = unit:GetTeam()
	local ai = AIManager:LoadAI( aiName, team )

	--Initialise the AI with the unit
	ai:Init( { team = team, unit = unit } )
end

--Get all AI heroes
function AIManager:GetAllAIHeroes()
	return AIManager.aiHeroes
end

--Get all heroes
function AIManager:GetAllHeroes()
	local heroes = {}
	local heroList = HeroList:GetAllHeroes()
	for _, hero in pairs(heroList) do
		if heroes[hero:GetTeam()] == nil then
			heroes[hero:GetTeam()] = {}
		end

		table.insert(heroes[hero:GetTeam()], hero)
	end

	return heroes
end

--Get all heroes belonging to an AI team
function AIManager:GetAIHeroes( team )
	return AIManager.aiHeroes[ team ]
end

--Get all heroes belonging to an AI team wrapped
function AIManager:GetWrappedAIHeroes( team )
	local wrappedHeroes = {}

	for _, hero in pairs( AIManager.aiHeroes[ team ] ) do
		table.insert( wrappedHeroes, WrapUnit( hero, team ) )
	end

	return wrappedHeroes
end

--Initialise an AI player
function AIManager:AddAI( name, team, heroes )
	--Load an AI
	local ai = AIManager:LoadAI( name, team )
	AIManager.aiHandles[ team ] = ai
	AIManager.aiNames[ team ] = name

	--Make a dummy to use for visoin checks
	AIManager.visionDummies[ team ] = CreateUnitByName( 'npc_dota_thinker', Vector(0,0,0), false, nil, nil, team )
	AIManager.visionDummies[ team ]:AddNewModifier( nil, nil, 'modifier_dummy', {} ) --Apply the dummy modifier

	--Request heroes
	for i, hero in ipairs( heroes ) do
		table.insert( AIManager.playerRequests, { team = team, hero = hero } )
		Tutorial:AddBot( hero, '', '', false )
	end

	AIManager.numPlayers = AIManager.numPlayers + #heroes

	return ai
end

--Load a sandboxed AI player
function AIManager:LoadAI( name, team )
	--Define custom _G
	local global = {}
	global.AIWrapper = AIWrapper( team )
	global.AIEvents = AIEvents( team )
	global.AIPlayerResource = AIPlayerResource( team )

	--Populate global functions
	global = AIManager:PopulateAIGlobals( name, global, global.AIWrapper )

	--Load file in sandbox
	local script = assert(loadfile('AI.UserAI.'..name..'.ai_init'))
	setfenv( script, global )
	return script()
end

--Make wrapper functions available globally to the AI
function AIManager:PopulateAIGlobals( name, global, wrapper )
	
	--Lua defaults
	global.math = math
	global.table = table
	global.bit = bit
	global.print = print
	global.pairs = pairs
	global.ipairs = ipairs
	global.type = type
	global.string = string
	global._G = global
	global.pcall = pcall
	global.debug = debug

	--Enable the require function, but only for the sandboxed environment
	global.require = function( filename )
		--Only load from the AI folder
		local script = assert(loadfile( 'AI.UserAI.'..name..'.'..filename ))
		setfenv( script, global )
		script()
	end

	--Auxiliary includes
	global.DeepPrintTable = DeepPrintTable
	global.Timers = Timers
	global.Vector = Vector
	global.Dynamic_Wrap = Dynamic_Wrap
	global.Warning = Warning
	global.AIUnitTests = AIUnitTests
	global.class = class

	--Enable the LoadKeyValues function but set the AI directory as root
	global.LoadKeyValues = function( path )
		return LoadKeyValues( 'scripts/vscripts/AI/UserAI/'..name..'/'..path )
	end

	--Default Dota global functions
	global.GetItemCost = GetItemCost
	global.RandomFloat = RandomFloat
	global.RandomInt = RandomInt
	global.RandomVector = RandomVector
	global.RotateOrientation = RotateOrientation
	global.RotatePosition = RotatePosition
	global.RotateQuaternionByAxisAngle = RotateQuaternionByAxisAngle
	global.RotationDelta = RotationDelta

	--Overriden Dota global functions
	function global.AI_FindUnitsInRadius( ... ) return wrapper:AI_FindUnitsInRadius( ... ) end
	function global.AI_EntIndexToHScript( ... ) return wrapper:AI_EntIndexToHScript( ... ) end
	function global.AI_MinimapEvent( ... ) return wrapper:AI_MinimapEvent( ... ) end
	function global.AI_ExecuteOrderFromTable( ... ) return wrapper:AI_ExecuteOrderFromTable( ... ) end
	function global.AI_Say( ... ) return wrapper:AI_Say( ... ) end
	function global.AI_BuyItem( ... ) return wrapper:AI_BuyItem( ... ) end
	function global.AI_GetGameTime( ... ) return wrapper:AI_GetGameTime( ... ) end
	function global.AI_Log( ... ) return wrapper:AI_Log( ... ) end
	function global.DebugDrawBox( ... ) return wrapper:DebugDrawBox( ... ) end
	function global.DebugDrawCircle( ... ) return wrapper:DebugDrawCircle( ... ) end
	function global.DebugDrawSphere( ... ) return wrapper:DebugDrawSphere( ... ) end
	function global.DebugDrawLine( ... ) return wrapper:DebugDrawLine( ... ) end
	function global.DebugDrawText( ... ) return wrapper:DebugDrawText( ... ) end

	--Copy over constants
	for k, v in pairs( _G ) do
		if type( v ) == 'string' or type( v ) == 'number' then
			global[k] = v
		end
	end

	return global
end