use sdl2
import sdl2/Core

import vamos/[Graphic, Entity, AssetCache]
import vamos/display/[Texture, SceneRenderer]
import vamos/graphics/SpriteMap

SpriteFont: class extends SpriteMap {
	
	text:String
	
	init: func (path:String, charW, charH:UInt, =text) {
		super(path, charW, charH)
	}
	
	init: func ~noText (path:String, charW, charH:UInt) {
		init(path, charW, charH, "")
	}
	
	init: func ~defaultFont (=text) {
		init("vamos/font_temp.png", 8, 10, text)
	}
	
	set: func (=text)
	
	draw: func (renderer:SceneRenderer, entity:Entity, x, y: Double) {
		count := 0
		for (c in text) {
			frame = c as Int
			super(renderer, entity, x + count * frameWidth, y)
			count += 1
		}
	}
}
