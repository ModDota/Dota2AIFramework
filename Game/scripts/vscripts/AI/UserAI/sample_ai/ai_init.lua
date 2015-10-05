--[[
	Sample AI

	Sample AI to demonstrate and test the AI competition framework.

	Code: Perry
	Date: October, 2015
]]

--Define AI object
local AI = {}

--Initialisation function, called by the framework with parameters
function AI:Init( params )
	print( 'Sample AI: Hello world!' )

	--Save team
	self.team = params.team
	self.heroes = params.heroes

	--Register event
	AIEvents:RegisterEventListener( 'entity_hurt', function( event ) DeepPrintTable(event) end, self )

	--Start thinker
	Timers:CreateTimer( function()
		return self:Think()
	end)

	self.state = 0

	AIUnitTests:Run( _G, self.heroes[1], self.heroes[1]:GetAbilityByIndex( 0 ), AIPlayerResource )
end

--AI think function
function AI:Think()
	local units = AI_FindUnitsInRadius( Vector( 0, 0, 0 ), nil, -1, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )

	--calc avg position
	local avg = Vector( 0, 0, 0 )
	local n = 0
	if #units > 0 then
		for _, unit in pairs( units ) do
			n = n + 1
			avg = avg + unit:GetAbsOrigin()
		end
	end

	avg = avg * (1/n)

	for _, hero in pairs( self.heroes ) do
		if self.state == 0 then
			--Go to avg
			AI_ExecuteOrderFromTable({
				UnitIndex = hero:GetEntityIndex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = avg + RandomVector( 100 )
			})
		else
			--Go away from avg
			local diff = (hero:GetAbsOrigin() - avg):Normalized()
			AI_ExecuteOrderFromTable({
				UnitIndex = hero:GetEntityIndex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = hero:GetAbsOrigin() + diff * 500
			})
		end
	end

	self.state = ( self.state + 1 ) % 2

	return 2
end

--Return the AI object <-- IMPORTANT
return AI