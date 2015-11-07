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

	--Save params
	self.team = params.team
	self.hero = params.heroes[1]
	self.heroIndex = self.hero:GetEntityIndex()
	self.data = params.data

	--Define some team-based parameters the AI needs
	if params.team == DOTA_TEAM_GOODGUYS then
		self.LANE_CENTER = Vector( -647, -287, 17 )
		self.HIGH_GROUND_POS = Vector( -1041, -585, 128 )
		self.NEAR_TOWER_POS = Vector( -1640, -1228, 128 )
		self.FOUNTAIN_POS = Vector( -6817, -6347, 385 )
	else
		self.LANE_CENTER = Vector( -647, -287, 17 )
		self.HIGH_GROUND_POS = Vector( -168, 85, 128 )
		self.NEAR_TOWER_POS = Vector( 610, 386, 128 )
		self.FOUNTAIN_POS = Vector( 6733, 6116, 385 )
	end

	--Register event listeners
	AI:RegisterEventListeners()

	--Start thinker
	Timers:CreateTimer( function()
		return self:Think()
	end)

	--Go to
	self.mainStM = self:SetUpStateMachine()
	self.mainStM:GotoState( 'Buying' )
	self.itemProgression = 0
	MoveUnitTo( self.hero, self.HIGH_GROUND_POS )
end

function AI:RegisterEventListeners()
	--Listen to the entity hurt event for the AI hero
	AIEvents:RegisterEventListener( 'entity_hurt', function( event )
		if event.entindex_killed == self.heroIndex then
			AI:OnTakeDamage( event )
		end
	end)
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
	statemachine:AddState( 'SafeRegen', Dynamic_Wrap( AI, 'SafeRegen' ) )

	return statemachine
end

--AI think function
function AI:Think()

	DebugDrawCircle( self.hero:GetAbsOrigin() + self.hero:GetForwardVector() * 200, Vector( 0, 255, 0 ), 10, 250, true, 0.5 )
	DebugDrawCircle( self.hero:GetAbsOrigin() + self.hero:GetForwardVector() * 450, Vector( 0, 255, 0 ), 10, 250, true, 0.5 )
	DebugDrawCircle( self.hero:GetAbsOrigin() + self.hero:GetForwardVector() * 700, Vector( 0, 255, 0 ), 10, 250, true, 0.5 )

	TryAndReport( self.AbilityPointThink, self )
	TryAndReport( self.mainStM.Think, self.mainStM )
	--pcall(AI.AbilityPointThink, self)
	--pcall(self.mainStM.Think, self.mainStM)

	return 0.5
end

--Think about ability points
function AI:AbilityPointThink()

	local levelTable = {
		'nevermore_necromastery', 	--1
		'nevermore_dark_lord',		--2
		'nevermore_dark_lord',		--3
		'nevermore_necromastery',	--4
		'nevermore_dark_lord',		--5
		'nevermore_necromastery',	--6
		'nevermore_dark_lord',		--7
		'nevermore_necromastery',	--8
		'nevermore_shadowraze1',	--9
		'nevermore_shadowraze1',	--10
		'nevermore_shadowraze1',	--11
		'nevermore_shadowraze1',	--12
		'attribute_bonus',			--13
		'attribute_bonus',			--14
		'attribute_bonus',			--15
		'attribute_bonus',			--16
		'attribute_bonus',			--17
		'attribute_bonus',			--18
		'attribute_bonus',			--19
		'attribute_bonus',			--20
		'attribute_bonus',			--21
		'attribute_bonus',			--22
		'nevermore_requiem',		--23
		'nevermore_requiem',		--24
		'nevermore_requiem'			--25
	}

	local abilityPoints = self.hero:GetAbilityPoints()

	if abilityPoints > 0 then
		for i=1,abilityPoints do
			AI_Log('leveling '..levelTable[ self.hero:GetLevel() - i + 1 ] )
			UnitLevelUpAbility( self.hero, self.hero:FindAbilityByName( levelTable[ self.hero:GetLevel() - i + 1 ] ) )
		end
	end
end

--Buy items
function AI:BuyItems()
	local itemTable = {
		'item_tango',
		'item_wraith_band',
		'item_bottle',
		'item_boots',
		'item_belt_of_strength',
		'item_gloves',
		'item_ring_of_basilius'
	}

	while self.itemProgression < #itemTable and 
		self.hero:GetGold() > GetItemCost( itemTable[self.itemProgression + 1] ) do
		UnitBuyItem( self.hero, itemTable[self.itemProgression + 1] )
		self.itemProgression = self.itemProgression + 1
	end 
end

--Decide how to go to lane ( walking/TP )
function AI:GoToLane()
	MoveUnitTo( self.hero, self.HIGH_GROUND_POS )
end

function AI:OnTakeDamage( event )
	local attacker = AI_EntIndexToHScript( event.entindex_attacker )
	if attacker:IsTower() or attacker:IsHero() or ( self.hero:GetHealth()/self.hero:GetMaxHealth() ) < 0.6 then
		self.pushStates:GotoState( 'SafeRegen', { entryTime = AI_GetGameTime() } )
		if DistanceUnitTo( self.hero, self.HIGH_GROUND_POS ) < DistanceUnitTo( self.hero, self.LANE_CENTER ) then
			MoveUnitTo( self.hero, self.NEAR_TOWER_POS )
		else
			MoveUnitTo( self.hero, self.NEAR_TOWER_POS )
		end
	end
end

--Return the AI object <-- IMPORTANT
return AI