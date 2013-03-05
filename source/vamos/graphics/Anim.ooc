import vamos/Graphic

Anim: class extends Graphic {
	
	frames: Int[]
	speed: Int
	looping: Bool
	playing: Bool
	
	_currentIndex: Int
	_tick: Int
	
	init: func (=frames, =speed, =looping) {
		_tick = 0
		_currentIndex = 0
	}
	
	currentFrame: func -> Int {
		frames[_currentIndex]
	}
	
	play: func (reset: Bool) {
		playing = true
		if (reset)
			_currentIndex = 0
		_tick = 0
	}
	
	pause: func {
		playing = false
	}
	
	update: func {
		if (!playing) return
		
		_tick += 1
		if (_tick == speed) {
			
			if (_currentIndex + 1 == frames length) {
				if (looping) {
					_currentIndex = 0
				}
			} else {
				_currentIndex += 1
			}
			_tick = 0
		}
	}
}