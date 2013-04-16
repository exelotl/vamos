import vamos/[Entity, Mask]
import vamos/masks/Hitbox

Grid: class extends Mask {
	
	data: UInt*
	width, height: UInt // size in pixels
	w, h: UInt  // size in tiles
	tileW, tileH: UInt
	
	init: func (=w, =h, =tileW, =tileH) {
		width = w * tileW
		height = h * tileH
	}
	
	get: inline func(x, y:UInt) -> UInt {
		(x < w && y < h) ? data[x + y*w] : 0
	}
	set: inline func(x, y, val:UInt) {
		if (x < w && y < h)
			data[x + y*w] = val
	}
	
	check: func (other:Mask) -> Bool {
		return match (other class) {
			case Hitbox => checkHitbox(other as Hitbox)
			case => false
		}
	}
	
	// local left = e.x + box.x
	// local top = e.y + box.y
	// local right = left + box.width
	// local bottom = top + box.height
	// left, top = math.floor((left-1)/TILE_SIZE) + 1, math.floor((top-1)/TILE_SIZE) + 1
	// right, bottom = math.floor((right-1)/TILE_SIZE) + 1, math.floor((bottom-1)/TILE_SIZE) + 1
	
	checkHitbox: func (box:Hitbox) -> Bool {
		if (!data) return false
		left:Int = box entity x + box x
		top:Int = box entity y + box y
		right:Int = (left + box width) / tileW
		bottom:Int = (top + box height) / tileH
		left /= tileW
		top /= tileH
		
		for (x in left..right+1)
			for (y in top..bottom+1)
				if (get(x, y)) return true
		false
	}
	
}
