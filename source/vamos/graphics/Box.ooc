use sdl2
import sdl2/Core
import vamos/[Engine, Graphic, Entity]
import vamos/display/[Texture, Screen, Color]

/*
 * How the borders and fill should be drawn in regard to the source image
 * Stretch is mush faster, but you want detail in the border and/or the fill, you'll need to use repeat
 */
FillMode: enum {
	STRETCH
	REPEAT
}

Box: class extends Graphic {
	borderW, borderH: Int
	width, height: Int
	fill? := true // Definitely turn this off if you're using repeated mode
	borders? := true
	corners? := true
	mode := FillMode STRETCH
	
	texture: Texture
	
	dstRect: SdlRect
	srcRect: SdlRect
	
	innerW: Int {
		get { width - 2*borderW }
		set (v) { width = v + 2*borderW }
	}
	innerH: Int {
		get { height - 2*borderH }
		set (v) { height = v + 2*borderH }
	}
		
	init: func~path (key:String, =width, =height, =borderW, =borderH) {
		texture = vamos assets getTexture(key)
	}
	
	init: func~texture (=texture, =width, =height, =borderW, =borderH)
	
    enclose: func ~nopos(w, h: Int) {
        enclose(0, 0, w, h)
    }
    enclose: func(x, y, w, h: Int) {
        this x = x - borderW
        this y = y - borderH
        innerW = w
        innerH = h
    }
    
    _repeat: func(top, step: Int, f: Func(Int)) {
        r := top
        i := step
        while (r > 0) {
            if (r < step) {
                i = r
            }
            f(i)
            r -= step
        }
    }
    
	draw: func (screen: Screen, entity: Entity, x, y: Float) {
		srcMidW := texture width - borderW * 2
		srcMidH := texture height - borderH * 2	
		dstMidW := innerW
		dstMidH := innerH
		
		if (dstMidW < 1 || dstMidH < 1 || srcMidW < 1 || srcMidH < 1) return
		
		if (corners?) {
			// Top left
			srcRect = (0, 0, borderW, borderH) as SdlRect
			dstRect = (x, y, borderW, borderH) as SdlRect
			screen drawTexture(texture, srcRect&, dstRect&)

			// Top Right
			srcRect = (texture width - borderW, 0, borderW, borderH) as SdlRect
			dstRect = (    x + width - borderW, y, borderW, borderH) as SdlRect
			screen drawTexture(texture, srcRect&, dstRect&)

			// Bottom Left
			srcRect = (0, texture height - borderH, borderW, borderH) as SdlRect
			dstRect = (x,     y + height - borderH, borderW, borderH) as SdlRect
			screen drawTexture(texture, srcRect&, dstRect&)

			// Bottom Right
			srcRect = (texture width - borderW, texture height - borderH, borderW, borderH) as SdlRect
			dstRect = (    x + width - borderW,     y + height - borderH, borderW, borderH) as SdlRect
			screen drawTexture(texture, srcRect&, dstRect&)
		}
        
		if (borders?) {
			// Left
			srcRect = (0, borderH, borderW, srcMidH) as SdlRect
			dstRect = (x, y+borderH, borderW, dstMidH) as SdlRect

			match (mode) {
				case FillMode STRETCH =>
					screen drawTexture(texture, srcRect&, dstRect&)

				case FillMode REPEAT =>
					_repeat(dstMidH, srcMidH, |h|
						srcRect h = dstRect h = h
						screen drawTexture(texture, srcRect&, dstRect&)
						dstRect y += h
					)
			}

			// Right
			srcRect = (texture width - borderW, borderH, borderW, srcMidH) as SdlRect
			dstRect = (x + width - borderW, y + borderH, borderW, dstMidH) as SdlRect

			match (mode) {
				case FillMode STRETCH =>
					screen drawTexture(texture, srcRect&, dstRect&)

				case FillMode REPEAT =>
					_repeat(dstMidH, srcMidH, |h|
						srcRect h = dstRect h = h
						screen drawTexture(texture, srcRect&, dstRect&)
						dstRect y += h
					)
			}

			// Top
			srcRect = (borderW, 0, srcMidW, borderH) as SdlRect
			dstRect = (x+borderW, y, dstMidW, borderH) as SdlRect

			match (mode) {
				case FillMode STRETCH =>
					screen drawTexture(texture, srcRect&, dstRect&)

				case FillMode REPEAT =>
					_repeat(dstMidW, srcMidW, |w|
						srcRect w = dstRect w = w
						screen drawTexture(texture, srcRect&, dstRect&)
						dstRect x += w
					)
			}

			// Bottom
			srcRect = (borderW, texture height - borderH, srcMidW, borderH) as SdlRect
			dstRect = (x + borderW, y + height - borderH, dstMidW, borderH) as SdlRect

			match (mode) {
				case FillMode STRETCH =>
					screen drawTexture(texture, srcRect&, dstRect&)

				case FillMode REPEAT =>
					_repeat(dstMidW, srcMidW, |w|
						srcRect w = dstRect w = w
						screen drawTexture(texture, srcRect&, dstRect&)
						dstRect x += w
					)
			}
		}
		
		if (fill?) {
			srcRect = (borderW, borderH, srcMidW, srcMidH) as SdlRect
			dstRect = (x + borderW, y + borderH, dstMidW, dstMidH) as SdlRect
				
			match (mode) {
				case FillMode STRETCH =>
					screen drawTexture(texture, srcRect&, dstRect&)

				case FillMode REPEAT =>
                    startY := dstRect y
                    _repeat(dstMidW, srcMidW, |w|
                        srcRect w = dstRect w = w
                        _repeat(dstMidH, srcMidH, |h|
                            srcRect h = dstRect h = h
                            screen drawTexture(texture, srcRect&, dstRect&)
                            dstRect y += h
                        )
                        dstRect y = startY
                        dstRect x += w
                    )
			}
		}
	}
}