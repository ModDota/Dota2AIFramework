--=====================================================================
-- State code
--=====================================================================
function AI:Pushing( state )
	self.pushStates:Think()
end

function AI:Backing( state )

end

function AI:Buying( state )

end

function AI:ToLane( state )
	if DistanceUnitTo( self.hero, self.LANE_CENTER ) < 1000 then
		self.mainStM:GotoState( 'Pushing' )
		return
	end

	AggressiveMoveUnitTo( self.hero, self.HIGH_GROUND_POS, true )
end

function AI:Attacking( state )
	local friendlyCreeps = FindCreeps( self.LANE_CENTER, 1500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, FIND_CLOSEST )
	local enemyCreeps = FindCreeps( self.LANE_CENTER, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, FIND_CLOSEST )

	if #friendlyCreeps <= 1 then
		self.pushStates:GotoState( 'Waiting' )
		MoveUnitTo( self.hero, self.NEAR_TOWER_POS )
		return
	end

	UnitAttackTarget( self.hero, enemyCreeps[1], true )
end

function AI:Waiting( state )
	self.pushStates:GotoState( 'Attacking' )
end