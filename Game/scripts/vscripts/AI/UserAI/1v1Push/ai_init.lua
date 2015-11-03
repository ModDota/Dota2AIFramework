--[[
	Sample AI

	Sample AI to demonstrate and test the AI competition framework.

	Code: Perry
	Date: October, 2015
]]

--Define AI object
AI = {}

require( 'StateMachine' )
require( 'AIStateCode' )
require( 'AIUtil' )

--Initialisation function, called by the framework with parameters
function AI:Init( params )
	AI_Log( 'Hello world!' )

	print( params.team )

	if params.team == DOTA_TEAM_GOODGUYS then
		self.LANE_CENTER = Vector( -647, -287, 17 )
		self.HIGH_GROUND_POS = Vector( -1041, -585, 128 )
		self.NEAR_TOWER_POS = Vector( -1640, -1228, 128 )
	else
		self.LANE_CENTER = Vector( -647, -287, 17 )
		self.HIGH_GROUND_POS = Vector( -168, 85, 128 )
		self.NEAR_TOWER_POS = Vector( 610, 386, 128 )
	end

	--Save team
	self.team = params.team
	self.hero = params.heroes[1]
	self.data = params.data

	for k,v in pairs( self.data ) do
		print( k, v )
	end

	--Start thinker
	Timers:CreateTimer( function()
		return self:Think()
	end)

	self.mainStM = self:SetUpStateMachine()
	self.mainStM:GotoState( 'ToLane' )

	MoveUnitTo( self.hero, self.HIGH_GROUND_POS )
end

function AI:SetUpStateMachine()
	local statemachine = StateMachine( self )

	self.pushStates = self:SetUpPushingStateMachine( self )

	statemachine:AddState( 'Pushing', Dynamic_Wrap( AI, 'Pushing' ) )
	statemachine:AddState( 'Backing', Dynamic_Wrap( AI, 'Backing' ) )
	statemachine:AddState( 'Buying', Dynamic_Wrap( AI, 'Buying' ) )
	statemachine:AddState( 'ToLane', Dynamic_Wrap( AI, 'ToLane' ) )

	return statemachine
end

function AI:SetUpPushingStateMachine()
	local statemachine = StateMachine( self )

	statemachine:AddState( 'Attacking', Dynamic_Wrap( AI, 'Attacking' ) )
	statemachine:AddState( 'Waiting', Dynamic_Wrap( AI, 'Waiting' ) )

	return statemachine
end

--AI think function
function AI:Think()

	self.mainStM:Think()

	return 1
end

--Return the AI object <-- IMPORTANT
return AI