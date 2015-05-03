use sdl2
import sdl2/[Core, Event]
import structs/ArrayList

Input: class {
	
	onQuit: static Func = func {}
	
	mouseX, mouseY: static Int
	
	mouseHeld: static Bool
	mousePressed: static Bool
	mouseReleased: static Bool
	
	rightMouseHeld: static Bool
	rightMousePressed: static Bool
	rightMouseReleased: static Bool
	
	scrollX: static Int
	scrollY: static Int
	
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
		
		mousePressed = mouseReleased = false
		rightMousePressed = rightMouseReleased = false
		scrollX = scrollY = 0
		
		while (SdlEvent poll(event&)) {
			
			match (event type) {
				case SDL_MOUSEMOTION =>
					mouseX = event motion x
					mouseY = event motion y

				case SDL_MOUSEBUTTONDOWN =>
					match (event button button) {
						case SDL_BUTTON_LEFT =>
							mousePressed = true
							mouseHeld = true
						case SDL_BUTTON_RIGHT =>
							rightMousePressed = true
							rightMouseHeld = true
					}

				case SDL_MOUSEBUTTONUP =>
					match (event button button) {
						case SDL_BUTTON_LEFT =>
							mouseReleased = true
							mouseHeld = false
						case SDL_BUTTON_RIGHT =>
							rightMouseReleased = true
							rightMouseHeld = false
					}
			
				case SDL_MOUSEWHEEL =>
					scrollX = event wheel x
					scrollY = event wheel y
                    
					/*
					* Wheel direction not currently supported in ooc-sdl2

					if (event wheel direction == SDL_MOUSEWHEEL_FLIPPED) {
						scrollX *= -1
						scrollY *= -1
					}

					*/

				case SDL_QUIT =>
					Input onQuit()
			}
		}
		
	}
	
}