use sdl2
import sdl2/Core
import vamos/[Graphic, Entity]
import vamos/display/[Screen, Color]

FilledRect: class extends Graphic {
	
	rect: SdlRect
	color: Color
	
	width: UInt16 {
		set (v) { rect w = v }
		get { rect w }
	}
	height: UInt16 {
		set (v) { rect h = v }
		get { rect h }
	}
	
	init: func (=width, =height, a,r,g,b:UInt8) { color set(a,r,g,b) }
	init: func~rgb (=width, =height, r,g,b:UInt8) { color set(255,r,g,b) }
	init: func~u32 (=width, =height, argb:UInt32) { color set(argb) }
	init: func~str (=width, =height, str:String) { color set(str) }
	
	center: func {
		x = rect w * -0.5
		y = rect h * -0.5
	}
	
	draw: func (screen:Screen, entity:Entity, x, y: Float) {
		rect x = x
		rect y = y
		screen fillRect(rect&, color r, color g, color b, color a)
	}
}