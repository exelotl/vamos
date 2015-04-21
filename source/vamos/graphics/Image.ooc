use sdl2
import sdl2/Core
import vamos/[Engine, Graphic, Entity]
import vamos/display/[Texture, Screen, Color]

Image: class extends Graphic {
	
	texture:Texture
	
	dstRect: SdlRect
	srcRect: SdlRect
	origin: SdlPoint
	
	width: UInt {
		get { srcRect w }
		set (v) { srcRect w = v }
	}
	height: UInt {
		get { srcRect h }
		set (v) { srcRect h = v }
	}
	
	color := (255,255,255,255) as Color
	alpha: UInt8 {
		get { color a }
		set (v) { color a = v }
	}
	
	scaleX: Float {
		get
		set (v) {
			dstRect w = srcRect w * v
			scaleX = v
		}
	}
	
	scaleY: Float {
		get
		set (v) {
			dstRect h = srcRect h * v
			scaleY = v
		}
	}
	
	_flip : Int
	flipX: Bool {
		get { (_flip & SDL_FLIP_HORIZONTAL) != 0 }
		set (v) {
			if (v) _flip |= SDL_FLIP_HORIZONTAL
			else _flip &= ~SDL_FLIP_HORIZONTAL
		}
	}
	flipY: Bool {
		get { (_flip & SDL_FLIP_VERTICAL) != 0 }
		set (v) {
			if (v) _flip |= SDL_FLIP_VERTICAL
			else _flip &= ~SDL_FLIP_VERTICAL
		}
	}
	
	angle:Double
	
	init: func~path (key:String) {
		texture = vamos assets getTexture(key)
		init(texture)
	}
	
	init: func~texture (=texture) {
		dstRect w = texture width
		dstRect h = texture height
		srcRect w = texture width
		srcRect h = texture height
		scaleX = 1
		scaleY = 1
	}
	
	center: func {
		origin x = srcRect w * 0.5
		origin y = srcRect h * 0.5
	}
	
	draw: func (screen:Screen, entity:Entity, x, y: Float) {
		dstRect x = x - origin x
		dstRect y = y - origin y
		texture color = color
		if (angle == 0 && _flip == 0) {
			screen drawTexture(texture, srcRect&, dstRect&)
		} else {
			screen drawTexture(texture, srcRect&, dstRect&, angle, null, _flip)
		}
	}
	
}
