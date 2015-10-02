--Libraries
require( 'Libraries.Timers' )

--Core files
require( 'AIFramework' )
require( 'AIWrapper' )

--Precache, not using this atm
function Precache( context ) end

--Activate the game mode
function Activate()
	--Initialise AI framework
	GameRules.Addon = AIFramework()
	GameRules.Addon:Init()
end
