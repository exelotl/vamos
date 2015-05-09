use sdl2
import sdl2/[Core, Event]
import structs/ArrayList

Input: class {
	
	onQuit: static Func = func {}
	
	mouseX, mouseY: static Int
	
	scrollX, scrollY: static Int
	
	_validMouseIds := static const 1..6
	mouseState, prevMouseState: static UInt8
	
	_numKeyStates: static Int
	keyStates, prevKeyStates: static Bool*
	
	_hasInitialized: static Bool
	
	// Should be called after SDL has initialized
	// Will be called automatically in update(), no need to call explicitly
	init: static func {
		keyStates = SDL getKeyboardState(_numKeyStates&)
		prevKeyStates = gc_malloc(Bool size * _numKeyStates)
		_hasInitialized = true
	}
	
	_flag: inline static func (id: Int) -> UInt8 {
		1 << (id-1)
	}
	_hasFlag: inline static func(word, flag: UInt8) -> Bool {
		(word & _flag(flag)) != 0
	}
	
	// Left mouse button = 1, middle = 2, right = 3, extended mouse buttons = 4 & 5
	// The common standard is right = 2 and middle = 3, should we switch it manually?
	// Or should there be consts LeftMouseButton, RightMouseButton etc. ?
	// Either way, There should probably be a better system than this
	
	mouseHeld: static func ~left -> Bool { mouseHeld(1) }
	middleMouseHeld: static func -> Bool { mouseHeld(2) }
	rightMouseHeld: static func -> Bool { mouseHeld(3) }
	
	mouseHeld: static func(id: Int) -> Bool {
		_hasFlag(mouseState, id)
	}
	
	mousePressed: static func ~left -> Bool { mousePressed(1) }
	middleMousePressed: static func -> Bool { mousePressed(2) }
	rightMousePressed: static func -> Bool { mousePressed(3) }
	
	mousePressed: static func(id: Int) -> Bool {
		_hasFlag(mouseState, id) && !_hasFlag(prevMouseState, id)
	}
	
	mouseReleased: static func ~left -> Bool { mouseReleased(1) }
	middleMouseReleased: static func -> Bool { mouseReleased(2) }
	rightMouseReleased: static func -> Bool { mouseReleased(3) }
	
	mouseReleased: static func(id: Int) -> Bool {
		!_hasFlag(mouseState, id) && _hasFlag(prevMouseState, id)
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
		if (name startsWith?("mouse")) {
			id: Int = name[5] - '0'
			if (id in?(_validMouseIds)) {
				return mouseHeld(id)
			}
		}
		held(SDL getKeyFromName(name))
	}
	
	pressed: static func ~byName (name:String) -> Bool {
		if (name startsWith?("mouse")) {
			id: Int = name[5] - '0'
			if (id in?(_validMouseIds)) {
				return mousePressed(id)
			}
		}
		pressed(SDL getKeyFromName(name))
	}
	
	released: static func ~byName (name:String) -> Bool {
		if (name startsWith?("mouse")) {
			id: Int = name[5] - '0'
			if (id in?(_validMouseIds)) {
				return mouseReleased(id)
			}
		}
		released(SDL getKeyFromName(name))
	}
	
	update: static func () {
		
		if (!_hasInitialized) init()
		
		scrollX = scrollY = 0
		
		for (i in 0.._numKeyStates)
			prevKeyStates[i] = keyStates[i]
		
		prevMouseState = mouseState
		mouseState = SDL getMouseState(null, null)
		
		event: SdlEvent
		while (SdlEvent poll(event&)) {
			match (event type) {
				case SDL_MOUSEMOTION =>
					mouseX = event motion x
					mouseY = event motion y
					
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