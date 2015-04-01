use sdl2
import sdl2/Core
import math

import vamos/[Graphic, Entity, AssetCache]
import vamos/display/[Texture, Screen]
import vamos/graphics/Image

SpriteMap: class extends Image {
	
	frameWidth, frameHeight: Int
	_framesWide: Int
	
	frame: Int {
		get
		set (v) {
			srcRect x = (v % _framesWide) * frameWidth
			srcRect y = floor(v / _framesWide) * frameHeight
			frame = v
		}
	}
	
	init: func (path:String, =frameWidth, =frameHeight) {
		super(path)
		srcRect w = frameWidth
		srcRect h = frameHeight
		_framesWide = texture width / frameWidth
	}
	
	draw: func (screen:Screen, entity:Entity, x, y: Float) {
		dstRect w = frameWidth * scale
		dstRect h = frameHeight * scale
		super(screen, entity, x, y)
	}
}