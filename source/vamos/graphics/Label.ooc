use sdl2
import sdl2/Core

import vamos/[Graphic, Entity, AssetCache]
import vamos/display/[Texture, Screen]
import vamos/graphics/SpriteMap

Label: class extends SpriteMap {
	
	text:String
	
	init: func (path:String, charW, charH:UInt, =text) {
		super(path, charW, charH)
	}
	
	init: func ~defaultFont (=text) {
		init("vamos/font_temp.png", 8, 10, text)
	}
	
	set: func (=text)
	
	draw: func (screen:Screen, entity:Entity, x, y: Float) {
		dx := 0.0f
		dy := 0.0f
		for (c in text) {
			if (c == '\n') {
				dx = 0
				dy += frameHeight * scaleY
			} else {
				frame = c as Int
				super(screen, entity, x + dx, y + dy)
				dx += frameWidth * scaleX
			}
		}
	}
}
