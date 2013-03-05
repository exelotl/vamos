import structs/ArrayList

/*
	Inspired by AS3-Signals, by Rob Penner
	Dynamically-typed variable length argument are not supported, but you can sepcify any type to hold event information.
	If you don't need event information to be dispatched, you can use VoidSignal.
*/

/**
 * List of functions, each of which accepts a single argument of type T
 */
Signal: class <T> {
	listeners := ArrayList<ArgListener<T>> new()
	
	add: func (f:Func(T)) -> ArgListener<T> {
		l := ArgListener<T> new(f)
		listeners add(l)
		return l
	}
	
	remove: func (l:ArgListener<T>) {
		listeners remove(l)
	}
	
	dispatch: func (param:T) {
		for (l in listeners) l call(param)
	}
}

/**
 * Contains a function which accepts an argument of type T
 */
ArgListener: class <T> {
	f: Func(T)
	init: func(=f)
	call: func(param:T) { f(param) }
}

/**
 * List of functions which accept no arguments
 */
VoidSignal: class {
	listeners := ArrayList<VoidListener> new()
	
	add: func (f:Func) -> VoidListener {
		l := VoidListener new(f)
		listeners add(l)
		return l
	}
	
	remove: func (l:VoidListener) {
		listeners remove(l)
	}
	
	dispatch: func {
		for (l in listeners) l call()
	}
}

/**
 * Contains a function which accepts no arguments
 */
VoidListener: class {
	f: Func
	init: func(=f)
	call: func { f() }
}
