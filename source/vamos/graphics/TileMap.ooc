use sdl2
import sdl2/Core
import vamos/[Engine, Util, AssetCache, Graphic]
import vamos/Entity
import vamos/display/[StateRenderer, Texture]

// TODO finish this
// TODO split rendering into chunks, so that large map sizes don't break.

TileMap: class extends Graphic {
	
	source: Texture
	sourceW, sourceH: Int // size in tiles
	data: UInt*
	
	srcRect, dstRect: SdlRect
	width, height: Int // size in pixels
	w, h: Int  // size in tiles
	
	init: func ~path (path:String, .w, .h, tileW, tileH:UInt) {
		init(engine assets getTexture(path), w, h, tileW, tileH)
	}
	
	init: func ~texture (=source, =w, =h, tileW, tileH:UInt) {
		width = w * tileW
		height = h * tileH
		sourceW = source width / tileW
		sourceH = source height / tileH
		sourceW toString() println()
		sourceH toString() println()
		srcRect w = dstRect w = tileW
		srcRect h = dstRect h = tileH
	}
	
	get: inline func(x, y:UInt) -> UInt {
		(x < w && y < h) ? data[x + y*w] : 0
	}
	set: inline func(x, y, val:UInt) {
		if (x < w && y < h)
			data[x + y*w] = val
	}
	
	draw: func (renderer:StateRenderer, entity:Entity, x, y:Double) {
		if (!data) return
		
		startX:Int = (renderer camX - entity x) / dstRect w
		startY:Int = (renderer camY - entity y) / dstRect h
		screenW := renderer width / dstRect w + 2
		screenH := renderer height / dstRect h + 2
		offX := (startX) * dstRect w - (renderer camX - entity x)
		offY := (startY) * dstRect h - (renderer camY - entity y)
		
		for (x in 0..screenW) {
			dstRect x = offX + x * dstRect w
			dstRect y = offY
			
			for (y in 0..screenH) {
				val := get(x+startX, y+startY)
				if (val) {
					val -= 1
					srcRect x = val % sourceW * dstRect w
					srcRect y = (val / sourceW) * dstRect h
					renderer drawTexture(source, srcRect&, dstRect&)
				}
				dstRect y += dstRect h
			}
		}
	}
		
}