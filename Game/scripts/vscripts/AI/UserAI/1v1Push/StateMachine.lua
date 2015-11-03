StateMachine = class({})

function StateMachine:constructor( context )
	self.states = {}
	self.currentState = nil
	self.context = context
end

function StateMachine:AddState( name, state, statecontext )
	--Set default context
	if context == nil then
		context = {}
	end

	--Store state
	self.states[ name ] = { func = state, context = statecontext }

	--Set a default state in case no starting state is given
	if self.currentState == nil then
		self.currentState = self.states[ name ]
	end
end

function StateMachine:GotoState( name )
	if self.states[ name ] ~= nil then
		self.currentState = self.states[ name ]
	else
		Warning( string.format( 'State %s not found!', name ) )
	end
end

function StateMachine:Think()
	self.currentState.func( self.context, self.currentState.context )
end