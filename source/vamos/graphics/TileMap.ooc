use sdl2
import sdl2/Core
import vamos/[Engine, AssetCache, Graphic]
import vamos/display/[StateRenderer, Texture]

// TODO finish this
// TODO split rendering into chunks, so that large map sizes don't break.

TileMap: class extends Graphic {
	
	sheet: Texture
	canvas: Texture
	
	srcRect, destRect: SdlRect
	width, height: Int // size in pixels
	
	tileW, tileH: Int
	w, h: Int  // size in tiles
	
	init: func (path:String, .w, .h, .tileW, .tileH) {
		init(engine assets getTexture(path), w, h, tileW, tileH)
	}
	
	init: func (=sheet, =w, =h, =tileW, =tileH) {
		width = w * tileW
		height = h * tileH
		canvas = Texture new(width, height)
	}
	
	draw: func (renderer:StateRenderer, entity:Entity, x, y:Double) {
		
	}
		
}