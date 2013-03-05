use sdl2
import sdl2/Core
import structs/ArrayList

import vamos/[State, Entity]
import vamos/display/Texture
import vamos/Graphic

import vamos/AssetCache

// handles the rendering of all the entities in a state

StateRenderer: class {
	
	state: State
	target: SdlRenderer
	
	camX, camY:Double
	
	init: func (=target)
	
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
		if (!state) return
		
		col := state color
		SDL setRenderDrawColor(target, col r, col g, col b, col a)
		SDL renderClear(target)
		
		for (e in state entities) {
			graphic := e graphic
			if (graphic != null && graphic visible) {
				x := e x + graphic x - camX * graphic scrollX
				y := e y + graphic y - camY * graphic scrollY
				graphic draw(this, e, x, y)
			}
		}
		
		SDL renderPresent(target)
	}
	
}