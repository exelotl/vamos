use sdl2
import sdl2/[Core, Event]
import structs/ArrayList
import vamos/Signal

Input: class {
	
	onMouseMove := static Signal<SdlMouseMotionEvent> new()
	onMouseDown := static Signal<SdlMouseButtonEvent> new()
	onMouseUp := static Signal<SdlMouseButtonEvent> new()
	onKeyDown := static Signal<Int> new()
	onKeyUp := static Signal<Int> new()
	onQuit := static VoidSignal new()
	
	mouseX, mouseY: static Int
	mouseHeld: static Bool
	mousePressed: static Bool
	mouseReleased: static Bool
	
	_numKeyStates: static Int
	keyStates: static Bool*
	prevKeyStates: static Bool*
	
	_hasInitialized: static Bool
	
	// Should be called after SDL has initialized
	// Will be called automatically in update(), no need to call explicitly
	init: static func {
		keyStates = SDL getKeyboardState(_numKeyStates&)
		prevKeyStates = gc_malloc(Bool size * _numKeyStates)
		_hasInitialized = true
	}
	
	held: static func(sym:Int) -> Bool {
		return keyStates[SDL getScancodeFromKey(sym)]
	}
	pressed: static func(sym:Int) -> Bool {
		scancode := SDL getScancodeFromKey(sym)
		return keyStates[scancode] && !prevKeyStates[scancode]
	}
	released: static func(sym:Int) -> Bool {
		scancode := SDL getScancodeFromKey(sym)
		return prevKeyStates[scancode] && !keyStates[scancode]
	}
	
	held: static func ~byName (name:String) -> Bool {
		held(SDL getKeyFromName(name))
	}
	pressed: static func ~byName (name:String) -> Bool {
		pressed(SDL getKeyFromName(name))
	}
	released: static func ~byName (name:String) -> Bool {
		released(SDL getKeyFromName(name))
	}
	
	update: static func () {
		
		if (!_hasInitialized) init()
		
		event: SdlEvent
		
		for (i in 0.._numKeyStates)
			prevKeyStates[i] = keyStates[i]
		
		mouseHeld = mouseReleased = false
		
		while (SdlEvent poll(event&)) {
			
			match (event type) {
				case SDL_MOUSEMOTION =>
					mouseX = event motion x
					mouseY = event motion y
					onMouseMove dispatch(event motion)
				case SDL_MOUSEBUTTONDOWN =>
					mousePressed = true
					mouseHeld = true
					onMouseDown dispatch(event button)
				case SDL_MOUSEBUTTONUP =>
					mouseReleased = false
					mouseHeld = false
					onMouseUp dispatch(event button)
				case SDL_KEYDOWN =>
					onKeyDown dispatch(event key keysym sym)
				case SDL_KEYUP =>
					onKeyUp dispatch(event key keysym sym)
				case SDL_QUIT =>
					onQuit dispatch()
			}
		}
		
	}
	
}