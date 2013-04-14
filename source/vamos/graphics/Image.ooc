use sdl2
import sdl2/Core
import vamos/[Engine, Graphic, Entity]
import vamos/display/[Texture, SceneRenderer, Color]

Image: class extends Graphic {
	
	texture:Texture
	
	dstRect: SdlRect
	srcRect: SdlRect
	origin: SdlPoint
	
	color := (255,255,255,255) as Color
	alpha: UInt8 {
		get { color a }
		set (v) { color a = v }
	}
	
	scale: Double {
		get
		set (v) {
			dstRect w = srcRect w * v
			dstRect h = srcRect h * v
			scale = v
		}
	}
	
	angle:Double
	
	init: func~path (key:String) {
		texture = engine assets getTexture(key)
		init(texture)
	}
	
	init: func~texture (=texture) {
		dstRect w = texture width
		dstRect h = texture height
		srcRect w = texture width
		srcRect h = texture height
		scale = 1
	}
	
	center: func {
		origin x = srcRect w * 0.5
		origin y = srcRect h * 0.5
	}
	
	draw: func (renderer:SceneRenderer, entity:Entity, x, y: Double) {
		dstRect x = x + this x - origin x
		dstRect y = y + this y - origin y
		texture color = color
		if (angle == 0) {
			renderer drawTexture(texture, srcRect&, dstRect&)
		} else {
			renderer drawTexture(texture, srcRect&, dstRect&, angle, null, SDL_FLIP_NONE)
		}
	}
	
}
