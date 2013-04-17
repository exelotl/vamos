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
	
	play: func (=frames, =fps) {
		if (index >= frames length) index = 0
		if (t > speed) t = 0
		playing = true
		looping = true
	}
	
	once: func { looping = false }
	loop: func { looping = true }
	reset: func { index = 0 }
	pause: func { playing = false }
	stop: func { this reset() .pause() }
	stop: func~frame (=frame) { stop() }
	
	fps: Double {
		get { 1/speed }
		set(v) { speed = 1/v }
	}
	
	update: func (dt:Double) {
		if (!playing || frames length==0) return
		
		t += dt
		if (t > speed) {
			if (index + 1 >= frames length) {
				if (looping) index = 0
				else playing = false
			} else {
				index += 1
			}
			t -= speed
		}
		frame = frames[index]
	}
}

operator== (a, b:Int[]) -> Bool {
	a data == b data
}
operator!= (a, b:Int[]) -> Bool {
	a data != b data
}