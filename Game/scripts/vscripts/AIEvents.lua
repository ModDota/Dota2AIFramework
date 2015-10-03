--[[
	Dota 2 Event wrapper to be used by AI
]]

--Class definition
if AIEvents == nil then
	AIEvents = class({ 
		constructor = function( self, team ) 
			self.team = team
			self.numHandlers = 0
		end
	})
end

--Define event filters
local FilterFunctions = {
	['npc_spawned'] = function( params, team )
		--Fetch the spawned unit
		local unit = EntIndexToHScript( params.entindex )

		--Allow the event if it's in team vision
		if InVision( unit, team ) then
			return true
		end

		return false
	end,
	['entity_hurt'] = function( params, team )
		--Get hurt unit
		local hurtUnit = EntIndexToHScript( params.entindex_killed )

		--Check if the hurt unit is in vision
		if InVision( hurtUnit, team ) then
			return true
		end

		return false
	end
}

--Register an event listener
function AIEvents:RegisterEventListener( eventName, callback )
	ListenToGameEvent( eventName, function( s, params )
		--Wait one frame to prevent weirdness
		Timers:CreateTimer( function()
			--Get filter function
			local filter = FilterFunctions[ eventName ]

			--If the filter allows, fire the callback
			if filter and filter( params, self.team ) then
				callback( params )
			end
		end)
	end, self )
end