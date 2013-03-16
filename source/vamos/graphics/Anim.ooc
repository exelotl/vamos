import vamos/Graphic
import vamos/graphics/SpriteMap

Anim: class extends SpriteMap {
	
	frames: Int[]
	looping := true
	playing := false
	
	index: Int
	speed: Double
	t: Double
	
	init: func (path:String, .frameWidth, .frameHeight) {
		super(path, frameWidth, frameHeight)
		index = 0
	}
	
	play: func (=frames, fps:Double) {
		if (index+1 == frames length)
			index = 0
		speed = 1/fps
		playing = looping = true
		t = 0
	}
	
	once: func { looping = false }
	loop: func { looping = true }
	reset: func { index = 0 }
	pause: func { playing = false }
	stop: func { this reset() .pause() }
	
	update: func (dt:Double) {
		if (!playing || frames length==0) return
		
		t += dt
		if (t > speed) {
			if (index + 1 == frames length) {
				if (looping) index = 0
			} else {
				index += 1
			}
			t -= speed
		}
		frame = frames[index]
	}
}