use sdl2
import sdl2/Core
import structs/ArrayList
import text/StringTokenizer
import vamos/[Engine, Util, AssetCache, Graphic, Entity]
import vamos/display/[Screen, Texture, Bitmap]

/**
 * A small tilemap drawn to a texture, allowing it to be rendered in a single call
 * Use this for small maps (recommended max 2048*2048 pixels)
 */
TileChunk: class extends Graphic {
	
	source: Bitmap
	sourceW, sourceH: Int // size in tiles
	
	target: Bitmap
	texture: Texture
	data: UInt*
	
	srcRect, dstRect: SdlRect
	width, height: Int // size in pixels
	w, h: Int  // size in tiles
	
	firstValue := 1
	
	_dirty := false
	
	init: func ~path (path:String, .w, .h, tileW, tileH:UInt) {
		init(vamos assets getBitmap(path), w, h, tileW, tileH)
	}
	
	init: func ~bitmap (=source, =w, =h, tileW, tileH:UInt) {
		width = w * tileW
		height = h * tileH
		sourceW = source width / tileW
		sourceH = source height / tileH
		srcRect w = dstRect w = tileW
		srcRect h = dstRect h = tileH
		target = Bitmap new(width, height)
	}
	
	allocate: func {
		if (!data) {
			data = gc_malloc(w * h * UInt size)
			texture = Texture new(width, height)
		}
	}
	
	allocate: func~noTexture {
		if (!data) data = gc_malloc(w * h * UInt size)
	}
	
	get: func (x, y:UInt) -> UInt {
		(x < w && y < h) ? data[x + y*w] : 0
	}
	set: func (x, y, val:UInt) {
		if (x < w && y < h) {
			data[x + y*w] = val
			dstRect x = x * dstRect w
			dstRect y = y * dstRect h
			if (val >= firstValue) {
				val -= firstValue
				srcRect x = val % sourceW * dstRect w
				srcRect y = (val / sourceW) * dstRect h
				target copyPixels(source, srcRect&, dstRect&)
			} else {
				target clearRect(dstRect&)
			}
			_dirty = true
		}
	}
	
	/**
	 * Fill the map with data, using a function that returns the tile value at each given coordinate
	 */
	load: func (f:Func(Int, Int)->UInt) {
		allocate()
		for (x in 0..w)
			for (y in 0..h)
				set(x, y, f(x, y))
	}
	
	draw: func (renderer:Screen, entity:Entity, x, y:Float) {
		if (_dirty) {
			texture copyPixels(target)
		}
		renderer drawTexture(texture, null, ((x, y, width, height) as SdlRect)&)
	}
}
