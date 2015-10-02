--[[
	Dota 2 API Wrapper used to restrict access to functions by AI to keep the competition fair.
]]

--Class definition
if AIWrapper == nil then
	AIWrapper = class({ constructor = function( self, team ) self.team = team end})
end

--Overridden FindUnitsInRadius
function AIWrapper:FindUnitsInRadius()
	print( self.team )
end