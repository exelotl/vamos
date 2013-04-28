import math
import vamos/Component

// TODO looping mode, one-shot mode that doesn't auto remove

/**
 * Component that can be used to transition a value between two values over a specified period of time.
 * Example:
 *   Tween new(10, |n| alpha = Tween linear(0, 255, n))
 */
Tween: class extends Component {
	
	f: Func(Double)
	complete: Func = _doNothing
	duration, timer: Double
	playing := false
	
	init: func (=duration, =f)
	
	init: func~start (=duration, =f) {
		playing = true
	}
	
	update: func (dt:Double) {
		if (playing) {
			timer += dt
			if (timer >= duration) {
				timer = duration
				playing = false
				complete()
				entity remove(this)
			}
			f(timer/duration)
		}
	}
	
	then: func (=complete) -> This {
		this
	}
	
	//    .`
	//  .`
	linear: static func (a, b, mix:Double) -> Double {
		a + (b-a) * mix
	}
	
	//      .--
	//  __.'
	cosine: static func (a, b, mix:Double) -> Double {
		mix = (1 - cos(mix * PI)) * 0.5
		a + (b-a) * mix
	}
	
	//        /
	//  ___.-`
	cosineIn: static func (a, b, mix:Double) -> Double {
		mix = 1 - cos(mix * PI*0.5)
		a + (b-a) * mix
	}
	
	//    ,-'``
	//   /
	cosineOut: static func (a, b, mix:Double) -> Double {
		mix = cos((1-mix) * PI*0.5)
		a + (b-a) * mix
	}
}

_doNothing: static func
