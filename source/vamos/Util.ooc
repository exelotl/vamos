import math

deg: inline func (rad:Double) -> Double {
	rad * 180 / PI
}
rad: inline func (deg:Double) -> Double {
	deg * PI / 180
}
sign: inline func (n:Double) -> Double {
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

sign: inline func~int (n:Int) -> Int {
	(n > 0) ? 1 : ((n < 0) ? -1 : 0)
}
max: inline func~int (a, b: Int) -> Int {
	(a > b) ? a : b
}
min: inline func~int (a, b: Int) -> Int {
	(a < b) ? a : b
}
clamp: inline func~int (n, min, max: Int) -> Int {
	(n < min) ? min : ((n > max) ? max : n)
}

max: inline func~array (arr:Double[]) -> Double {
	n: Double = 0.0
	for (i in 0..arr length)
		if (arr[i] > n) n = arr[i]
	return n
}
min: inline func~array (arr:Double[]) -> Double {
	n: Double = 0.0
	for (i in 0..arr length)
		if (arr[i] < n) n = arr[i]
	return n
}
max: inline func~intArray (arr:Int[]) -> Int {
	n := 0
	for (i in 0..arr length)
		if (arr[i] > n) n = arr[i]
	return n
}
min: inline func~intArray (arr:Int[]) -> Int {
	n := 0
	for (i in 0..arr length)
		if (arr[i] < n) n = arr[i]
	return n
}

extend Double {
	clamp: inline func(min, max: This) -> This { clamp(this, min, max) }
	sign: inline func -> This { sign(this) }
	toRadians: inline func -> This { rad(this) }
	toDegrees: inline func -> This { deg(this) }
}

extend Int {
	clamp: inline func(min, max: This) -> This { clamp(this, min, max) }
	sign: inline func -> This { sign(this) }
}
extend UInt {
	clamp: inline func(min, max: This) -> This { clamp(this, min, max) }
}

Point: class {
	x, y: Double
	init: func
	init: func~pos(=x, =y)
	
	clone: inline func -> This {
		This new(x,y)
	}
}

Rect: class {
	x, y, w, h: Double
	init: func
	init: func~size(=w, =h)
	init: func~full(=x, =y, =w, =h)
	
	clone: inline func -> This {
		This new(x,y,w,h)
	}
}
