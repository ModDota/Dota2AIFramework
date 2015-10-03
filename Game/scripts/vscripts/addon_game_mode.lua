--Libraries
require( 'Libraries.Timers' )

--Core files
require( 'AIFramework' )

--Include AI
require( 'AI.AIManager' )
require( 'AI.AIWrapper' )
require( 'AI.AIEvents' )
require( 'AI.UnitWrapper' )
require( 'AI.AbilityWrapper' )

--Precache, not using this atm
function Precache( context ) end

--Activate the game mode
function Activate()
	--Initialise AI framework
	GameRules.Addon = AIFramework()
	GameRules.Addon:Init()
end
