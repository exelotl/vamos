use sdl2
import sdl2/Core
import vamos/[Graphic, Entity]
import vamos/display/[Screen, Color]

Overlay: class extends Graphic {
    
	color: Color
	
	init: func (r,g,b,a:UInt8) { color set(r,g,b,a) }
	init: func~rgb (r,g,b:UInt8) { color set(r,g,b,255) }
	init: func~u32 (rgba:UInt32) { color set(rgba) }
	init: func~str (str:String) { color set(str) }

	draw: func (screen:Screen, entity:Entity, x, y: Float) {
		screen fillRect(null, color r, color g, color b, color a)
	}
}