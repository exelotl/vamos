use sdl2
import sdl2/Core
import vamos/[Engine, Entity]
import vamos/graphics/Image
import vamos/display/Screen

/**
 * An image repeated/tiled a whole number of times.
 */
RepeatImage: class extends Image {
	
	repeatX := 1
	repeatY := 1
	
	init: super func
	
	center: func {
		origin x = srcRect w * 0.5
		origin y = srcRect h * 0.5
	}
	
	draw: func (screen:Screen, entity:Entity, x, y: Float) {
		for (lx in 0..repeatX)
			for (ly in 0..repeatY)
				super(screen, entity, x + lx*dstRect w, y + ly*dstRect h)
	}
	
}
