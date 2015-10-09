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
	self.hero = params.heroes[1]
	self.data = params.data

	--Set initial target
	self.moveTargetI = 0
	self.moveTarget = self.data.camps[1]

	AI_ExecuteOrderFromTable({
		UnitIndex = self.hero:GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = self.moveTarget
	})

	--Register event
	AIEvents:RegisterEventListener( 'entity_hurt', function( event ) DeepPrintTable(event) end, self )

	--Start thinker
	Timers:CreateTimer( function()
		return self:Think()
	end)

	self.state = 0

	AIUnitTests:Run( _G, self.hero, self.hero:GetAbilityByIndex( 0 ), AIPlayerResource )
end

--AI think function
function AI:Think()
	--Check if we're at the move target yet
	local distance = ( self.hero:GetAbsOrigin() - self.moveTarget ):Length2D()
	if distance < 10 then
		--Move to the next move target
		self.moveTargetI = ( self.moveTargetI + 1 ) % #self.data.camps
		self.moveTarget = self.data.camps[ self.moveTargetI + 1 ]

		AI_ExecuteOrderFromTable({
			UnitIndex = self.hero:GetEntityIndex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = self.moveTarget
		})
	end

	return 0.2
end

--Return the AI object <-- IMPORTANT
return AI