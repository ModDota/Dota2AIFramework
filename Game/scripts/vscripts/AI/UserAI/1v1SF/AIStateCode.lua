--=====================================================================
-- State code
--=====================================================================
function AI:Pushing( state )
	if ( self.hero:GetHealth()/self.hero:GetMaxHealth() ) < 0.3 then
		self.mainStM:GotoState( 'Backing' )
		MoveUnitTo( self.hero, self.FOUNTAIN_POS )
		AI_Log( 'Going back go base!' )
		return
	end

	if not self.hero:IsAlive() then
		self.mainStM:GotoState( 'Buying' )
		return
	end

	self.pushStates:Think()
end

function AI:Backing( state )
	if DistanceUnitTo( self.hero, self.FOUNTAIN_POS ) < 50 then
		self.mainStM:GotoState( 'Buying' )
		return
	end

	if not self.hero:IsAlive() then
		self.mainStM:GotoState( 'Buying' )
		return
	end

	MoveUnitTo( self.hero, self.FOUNTAIN_POS )
end

function AI:Buying( state )
	if ( self.hero:GetHealth()/self.hero:GetMaxHealth() ) > 0.85 then
		self.mainStM:GotoState( 'ToLane' )
		AI_Log('Going to lane now.')

		self:BuyItems()

		self:GoToLane()

		return
	end
end

function AI:ToLane( state )
	if DistanceUnitTo( self.hero, self.NEAR_TOWER_POS ) < 200 then
		self.mainStM:GotoState( 'Pushing' )
		self.pushStates:GotoState( 'Attacking' )
		return
	end

	MoveUnitTo( self.hero, self.NEAR_TOWER_POS, true )

	if not self.hero:IsAlive() then
		self.mainStM:GotoState( 'Buying' )
		return
	end
end

--========================================================================================================
--Push states
--========================================================================================================
function AI:Attacking( state )
	local friendlyCreeps = FindCreeps( self.LANE_CENTER, 1500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, FIND_ANY_ORDER )
	local targets = FindTargets( self.hero:GetAbsOrigin(), 4000, DOTA_UNIT_TARGET_TEAM_ENEMY, FIND_CLOSEST )

	if #friendlyCreeps < 1 then
		self.pushStates:GotoState( 'Waiting' )
		MoveUnitTo( self.hero, self.NEAR_TOWER_POS )
		return
	end

	--Attack the closest target
	if #targets > 0 and state.attackTarget ~= targets[1] then
		UnitAttackTarget( self.hero, targets[1] )
		state.attackTarget = targets[1]
	end
end

function AI:Waiting( state )
	local friendlyCreeps = FindCreeps( self.LANE_CENTER, 1500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, FIND_ANY_ORDER )
	local enemyCreeps = FindCreeps( self.LANE_CENTER, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, FIND_ANY_ORDER )

	local friendlyWavePos = AverageUnitPos( friendlyCreeps )
	local enemyWavePos = AverageUnitPos( enemyCreeps )

	if DistanceUnitTo( self.hero, friendlyWavePos ) < DistanceUnitTo( self.hero, enemyWavePos ) then
		self.pushStates:GotoState( 'Attacking' )
		return
	end

	AggressiveMoveUnitTo( self.hero, self.NEAR_TOWER_POS, true )
end

function AI:SafeRegen( state )
	if AI_GetGameTime() - state.entryTime > 1.5 then
		self.pushStates:GotoState( 'Attacking' )
		return
	end

	if ( AI_GetGameTime() - state.entryTime ) > 1 and ( self.hero:GetHealth()/self.hero:GetMaxHealth() ) <= 0.7 then
		local bottle = FindItemByName( self.hero, 'item_bottle' )
		if bottle ~= nil and bottle:GetCurrentCharges() > 0 and state.bottled == nil then
			state.bottled = true
			CastNoTarget( self.hero, bottle )
		end
	end
end