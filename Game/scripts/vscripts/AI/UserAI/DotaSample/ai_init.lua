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
	AI_Log( 'Sample DotA AI: Hello world!' )

	--Save team
	self.team = params.team
	self.data = params.data

	--List assigned heroes
	for _, hero in pairs(params.heroes) do
		print("Found assigned hero: "..hero:GetUnitName())
	end

	--Start thinker
	Timers:CreateTimer( function()
		return self:Think()
	end)

	self.state = 0
end

--AI think function
function AI:Think()
	-- Think - do something here

	return 2	
end

--Return the AI object <-- IMPORTANT
return AI