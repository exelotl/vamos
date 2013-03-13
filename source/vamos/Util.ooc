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

Point: cover {
	x, y: Double
	set: func(=x, =y)
}

Rect: cover {
	x, y, w, h: Double
	set: func(=x, =y, =w, =h)
	set: func~size(=w, =h)
}
