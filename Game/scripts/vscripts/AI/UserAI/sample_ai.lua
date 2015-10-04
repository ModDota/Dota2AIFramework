--[[
	Sample AI

	Sample AI to demonstrate and test the AI competition framework.

	Code: Perry
	Date: October, 2015
]]

require('AI.AIUnitTests')

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

	UnitTest( _G, self.heroes[1], self.heroes[1]:GetAbilityByIndex( 0 ) )
end

--AI think function
function AI:Think()
	local units = AI_FindUnitsInRadius( Vector( 0, 0, 0 ), nil, -1, 
			DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )

	--Try to set abs origin
	if #units > 0 then
		for _, unit in pairs( units ) do
			--print( unit )
		end
	end

	return 2
end

--Return the AI object <-- IMPORTANT
return AI