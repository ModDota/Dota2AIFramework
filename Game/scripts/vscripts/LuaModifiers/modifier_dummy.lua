modifier_dummy = class({})

--Set the dummy out of the game
function modifier_dummy:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true
	}

	return state
end