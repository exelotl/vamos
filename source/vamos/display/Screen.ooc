use sdl2
import sdl2/Core
import structs/ArrayList

import vamos/[Scene, Entity]
import vamos/display/[Texture, Color]
import vamos/Graphic

import vamos/AssetCache

// handles the rendering of all the entities in a scene

Screen: class {
	
	scene: Scene
	window: SdlWindow
	target: SdlRenderer
	
	format: UInt32 // pixel format
	width, height: Int
	color: Color
	camX, camY:Float
	
	init: func (=window, =target) {
		format = SDL getWindowPixelFormat(window)
		SDL renderGetLogicalSize(target, width&, height&)
	}
	
	drawTexture: inline func(texture:Texture, sourceRect, destRect:SdlRect*) {
		SDL renderCopy(target, texture data, sourceRect, destRect)
	}
	
	drawTexture: inline func~ex (texture:Texture, sourceRect, destRect:SdlRect*, angle:const Double, center:const SdlPoint*, flip:const Int) {
		SDL renderCopyEx(target, texture data, sourceRect, destRect, angle, center, flip)
	}
	
	fillRect: func (rect:SdlRect*, r,g,b,a:UInt8) {
		SDL setRenderDrawColor(target, r,g,b,a)
		SDL renderFillRect(target, rect)
	}
	
	
	draw: func {
		if (!scene) return
		
		SDL setRenderDrawBlendMode(target, SDL_BLENDMODE_BLEND)
		SDL setRenderDrawColor(target, color r, color g, color b, color a)
		SDL renderClear(target)
		
		for (l in scene layerOrder) {
			list:ArrayList<Entity> = scene layers get(l)
			for (e in list) {
				graphic := e graphic
				if (graphic != null && graphic visible) {
					x := e x + graphic x - camX * graphic scrollX
					y := e y + graphic y - camY * graphic scrollY
					graphic draw(this, e, x, y)
				}
			}
		}
		
		SDL renderPresent(target)
	}
	
}