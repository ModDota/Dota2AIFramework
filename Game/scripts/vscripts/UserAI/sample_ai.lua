--[[
	Sample AI used to test the AIFramework.
]]

--Define AI object
local AI = {}

--Initialisation function, called by the framework with parameters
function AI:Init( params )
	print( 'Sample AI: Hello world!' )

	--Save team
	self.team = params.team

	--Start thinker
	Timers:CreateTimer( AI.Think, self )
end

--AI think function
function AI:Think()
	local units = AI_FindUnitsInRadius( Vector( 0, 0, 0 ), nil, -1, 
			DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )

	--Try to set abs origin
	if #units > 0 then
		for _, unit in pairs( units ) do
			print( unit:GetAbsOrigin() )
		end
	end

	return 2
end

--Return the AI object <-- IMPORTANT
return AI