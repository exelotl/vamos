import vamos/[Entity, Mask]

Hitbox: class extends Mask {
	
	x, y, width, height : Float
	
	init: func (=width, =height, =x, =y)
	init: func~size (=width, =height)
	
	set: func (=width, =height, =x, =y)
	set: func~size (=width, =height)
	
	center: func {
		x = width * -0.5
		y = height * -0.5
	}
	
	check: func (other:Mask) -> Bool {
		return match (other class) {
			case Hitbox => checkHitbox(other as Hitbox)
			case => false
		}
	}
	
	checkHitbox: func(other:Hitbox) -> Bool {
		left := entity x + x
		top := entity y + y
		otherLeft := other entity x + other x
		otherTop := other entity y + other y
		
		return (left + width) > (otherLeft)       \
		    && (top + height) > (otherTop)        \
		    && (left) < (otherLeft + other width) \
		    && (top) < (otherTop + other height)
	}
	
}
