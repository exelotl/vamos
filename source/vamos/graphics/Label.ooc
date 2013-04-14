use sdl2
import sdl2/Core

import vamos/[Graphic, Entity, AssetCache]
import vamos/display/[Texture, SceneRenderer]
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
	
	draw: func (renderer:SceneRenderer, entity:Entity, x, y: Double) {
		dx:Double = 0
		dy:Double = 0
		for (c in text) {
			if (c == '\n') {
				dx = 0
				dy += frameHeight * scale
			} else {
				frame = c as Int
				super(renderer, entity, x + dx, y + dy)
				dx += frameWidth * scale
			}
		}
	}
}
