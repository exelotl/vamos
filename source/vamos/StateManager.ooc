import vamos/State

StateManager: class {
	
	state: State {
		get
		set (newState) {
			if (state != null) {
				state onLeave dispatch(newState)
			}
			if (!newState created) {
				newState create()
			}
			newState onEnter dispatch(state)
			state = newState
		}
	}
	
	init: func
	
	update: func (dt:Double) {
		if (state) state update(dt)
	}
}