use sdl2
import sdl2/Core
import structs/ArrayList
import text/StringTokenizer
import vamos/[Engine, Util, AssetCache, Graphic]
import vamos/Entity
import vamos/display/[Screen, Texture]

/**
 * A simple tilemap implementation, just renders the tiles that are visible on the screen.
 * Light on memory, but may have high CPU usage because the whole visible area is redrawn each frame. 
 */
TileMap: class extends Graphic {
	
	source: Texture
	sourceW, sourceH: Int // size in tiles
	data: UInt*
	
	srcRect, dstRect: SdlRect
	width, height: Int // size in pixels
	w, h: Int  // size in tiles
	
	firstValue := 1
	outOfBoundsValue := 0
	
	baseTileWidth, baseTileHeight: Int
	tileOffsetX, tileOffsetY: Int
	
	init: func ~path (path:String, .w, .h, tileW, tileH:UInt) {
		init(vamos assets getTexture(path), w, h, tileW, tileH)
	}
	
	init: func ~texture (=source, =w, =h, tileW, tileH:UInt) {
		baseTileWidth = tileW
		baseTileHeight = tileH
		width = w * tileW
		height = h * tileH
		sourceW = source width / tileW
		sourceH = source height / tileH
		srcRect w = dstRect w = tileW
		srcRect h = dstRect h = tileH
	}
	
	resize: func(=w, =h) {
		width = w * baseTileWidth
		height = h * baseTileHeight
		if (data) gc_realloc(w * h * UInt size)
	}
	
	setTileArea: func(=tileOffsetX, =tileOffsetY, =baseTileWidth, =baseTileHeight) {
		width = w * baseTileWidth
		height = h * baseTileHeight
	}
	
	get: inline func(x, y:UInt) -> UInt {
		(x < w && y < h) ? data[x + y*w] : outOfBoundsValue
	}
	set: inline func(x, y, val:UInt) {
		if (x < w && y < h)
			data[x + y*w] = val
	}
	
	allocate: func {
		if (!data) data = gc_malloc(w * h * UInt size)
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
	
	draw: func (renderer:Screen, entity:Entity, x, y:Float) {
		if (!data) return
		
		startX:Int = (renderer camX - entity x) / baseTileWidth - 1
		startY:Int = (renderer camY - entity y) / baseTileHeight - 1
		screenW := renderer width / baseTileWidth + 2
		screenH := renderer height / baseTileHeight + 2
		offX := startX * baseTileWidth - (renderer camX - entity x)
		offY := startY * baseTileHeight - (renderer camY - entity y)
		
		for (x in 0..screenW) {
			dstRect x = offX + x * baseTileWidth - tileOffsetX
			dstRect y = offY - tileOffsetY
			
			for (y in 0..screenH) {
				val := get(x+startX, y+startY)
				if (val >= firstValue) {
					val -= firstValue
					srcRect x = val % sourceW * dstRect w
					srcRect y = (val / sourceW) * dstRect h
					renderer drawTexture(source, srcRect&, dstRect&)
				}
				dstRect y += baseTileHeight
			}
		}
	}

	_isWhitespace: static func (s:String) -> Bool {
		for (c in s) {
			if (c != ' ' && c != '\r' && c != '\t' && c != '\n')
				return false
		}
		true
	}
	
}