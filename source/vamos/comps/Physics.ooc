import math
import structs/ArrayList
import vamos/[Util, Component, Entity]

Physics: class extends Component {
	
	types:ArrayList<String>
	
	/// Return true to collide, return false to keep moving
	onCollide: Func(Entity)->Bool = defaultHandler
	
	velX, velY: Float
	accX, accY: Float
	maxVelX := 99999.0f
	maxVelY := 99999.0f
	dragX, dragY: Float
	nudgeX, nudgeY: Float
	bounce: Float
	sweep := false
	
	init: func (=types) {
		name = "physics"
	}
	
	init: func ~noTypes {
		init(ArrayList<String> new())
	}
	
	init: func ~rawTypes (types:String[]) {
		init(types as ArrayList<String>)
	}

	update: func (dt:Float) {
		if (accX == 0) {
			if (velX < 0) velX = min(velX + dragX*dt, 0)
			else if (velX > 0) velX = max(velX - dragX*dt, 0)
		} else {
			velX = velX + accX*dt
		}
		
		if (velX < -maxVelX) velX = -maxVelX
		else if (velX > maxVelX) velX = maxVelX
		
		if (accY == 0) {
			if (velY < 0) velY = min(velY + dragY*dt, 0)
			else if (velY > 0) velY = max(velY - dragY*dt, 0)
		} else {
			velY = velY + accY*dt
		}
		
		if (velY < -maxVelY) velY = -maxVelY
		else if (velY > maxVelY) velY = maxVelY
		
		moveBy(velX*dt + nudgeX, velY*dt + nudgeY)
		nudgeX = 0
		nudgeY = 0
	}
	
	_fractionX:Float  // account for < 1px movement over many frames
	_fractionY:Float
	
	// Thanks Chevy!
	moveBy: func(x, y:Float) {
		_fractionX += x
		_fractionY += y
		x = _fractionX round()
		y = _fractionY round()
		_fractionX -= x
		_fractionY -= y
		
		sign:Float
		e:Entity
		
		if (x != 0) {
			if (sweep || entity collide(types, entity x + x, entity y)) {
				sign = x > 0 ? 1 : -1
				while (x != 0) {
					if (e = entity collide(types, entity x + sign, entity y)) {
						if (collideX(e)) break
					}
					entity x += sign
					x -= sign
				}
			} else {
				entity x += x
			}
		}
		
		if (y != 0) {
			if (sweep || entity collide(types, entity x, entity y + y)) {
				sign = y > 0 ? 1 : -1
				while (y != 0) {
					if (e = entity collide(types, entity x, entity y + sign)) {
						if (collideY(e)) break
					}
					entity y += sign
					y -= sign
				}
			} else {
				entity y += y
			}
		}
	}

	collideX: func (e:Entity) -> Bool {
		if (onCollide(e)) {
			velX = -velX * bounce
			return true
		}
		return false
	}

	collideY: func (e:Entity) -> Bool {
		if (onCollide(e)) {
			velY = -velY * bounce
			return true
		}
		return false
	}
	
	handle: func (f:Func(Entity)->Bool) {
		onCollide = f
	}
	
	defaultHandler: static func (e:Entity) -> Bool {
		true
	}
}
