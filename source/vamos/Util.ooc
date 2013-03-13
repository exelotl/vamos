import math

deg: func (rad:Double) -> Double {
	rad * 180 / PI
}

rad: func (deg:Double) -> Double {
	deg * PI / 180
}

sign: func (n:Double) -> Double {
	(n > 0) ? 1 : ((n < 0) ? -1 : 0)
}

max: inline func (a, b: Double) -> Double {
	(a > b) ? a : b
}

min: inline func (a, b: Double) -> Double {
	(a < b) ? a : b
}

clamp: func (n, min, max: Double) -> Double {
	(n < min) ? min : ((n > max) ? max : n)
}

extend Double {
	clamp: inline func(min, max: This) -> This { clamp(this, min, max) }
	sign: inline func -> This { sign(this) }
	toRadians: inline func -> This { rad(this) }
	toDegrees: inline func -> This { deg(this) }
}

Point: class {
	x, y: Double
	init: func
	init: func~pos(=x, =y)
	
	clone: inline func {
		Point new(x,y)
	}
}

Rect: class {
	x, y, w, h: Double
	init: func
	init: func~size(=w, =h)
	init: func~full(=x, =y, =w, =h)
	
	clone: inline func {
		Rect new(x,y,w,h)
	}
}
