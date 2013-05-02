import structs/ArrayList
import text/StringTokenizer
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
	
	allocate: func {
		if (!data) data = gc_malloc(w * h * UInt size)
	}
	
	get: inline func(x, y:UInt) -> UInt {
		(x < w && y < h) ? data[x + y*w] : 0
	}
	set: inline func(x, y, val:UInt) {
		if (x < w && y < h)
			data[x + y*w] = val
	}
	
	load: func ~fromString(str, colSep, rowSep: String) {
		allocate()
		if (_isWhitespace(str))
			return
		rows := str split(rowSep)
		for (y in 0..rows size) {
			row := rows[y]
			
			if (colSep=="") {
				for (x in 0..row size)
					set(x, y, row[x] toInt())
			} else {
				vals := row split(colSep, true)
				for (x in 0..vals size)
					set(x, y, vals[x] toInt())
			}
		}
	}
	
	check: func (other:Mask) -> Bool {
		return match (other class) {
			case Hitbox => checkHitbox(other as Hitbox)
			case => false
		}
	}
	
	checkHitbox: func (box:Hitbox) -> Bool {
		if (!data) return false
		left:Int = box entity x + box x - entity x
		top:Int = box entity y + box y - entity y
		right:Int = (left + box width - 1) / tileW
		bottom:Int = (top + box height - 1) / tileH
		left /= tileW
		top /= tileH
		
		for (x in left..right+1)
			for (y in top..bottom+1)
				if (get(x, y)) return true
		false
	}
	
}

_isWhitespace: static func (s:String) -> Bool {
	for (c in s) {
		if (c != ' ' && c != '\r' && c != '\t' && c != '\n')
			return false
	}
	true
}