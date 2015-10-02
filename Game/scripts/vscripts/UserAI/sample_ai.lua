--[[
	Sample AI used to test the AIFramework.
]]

--Define AI object
local AI = {}

--Initialisation function, called by the framework with parameters
function AI:Init( params )
	print( 'Sample AI: Hello world!' )

	--Do an empty FindUnitsInRadius to test if everything works
	AIWrapper:FindUnitsInRadius()
end

--Return the AI object <-- IMPORTANT
return AI