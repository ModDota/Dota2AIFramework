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
	AI_Log( 'Sample AI: Hello world!' )

	--Save team
	self.team = params.team
	self.hero = params.heroes[1]
	self.data = params.data

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
	AI_ExecuteOrderFromTable({
		UnitIndex = self.hero:GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = Vector( -2500, 1000, 0 )
	})

	return 2	
end

--Return the AI object <-- IMPORTANT
return AI