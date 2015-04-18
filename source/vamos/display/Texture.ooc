use sdl2
import sdl2/Core
import vamos/Engine
import ./[SurfaceLoader, Bitmap, Color]

/**
 * Wrapper object for SdlTexture
 * The engine must be initialised before textures can be created.
 */
Texture: class {
	
	data: SdlTexture
	width: Float
	height: Float
	
	init: func ~fromPath (path:String) {
		surface := SurfaceLoader load(path)
		if (surface == null) {
			"!! Error loading image '%s'" printfln(path)
			surface = SDL createRGBSurface(0, 8, 8, 32, 0,0,0,0) // init with placeholder 
		}
		init(surface)
		SDL freeSurface(surface)
	}
	
	init: func ~fromBitmap (bitmap:Bitmap) {
		init(bitmap surface)
	}
	
	init: func ~fromSurface (surface:SdlSurface*) {
		assertRendererExists()
		data = SDL createTextureFromSurface(vamos renderer, surface)
		width = surface@ w
		height = surface@ h
	}
	
	init: func ~empty (=width, =height, streaming := false) {
		assertRendererExists()
		fmt := SDL getWindowPixelFormat(vamos window)
		access := streaming ? SDL_TEXTUREACCESS_STREAMING : SDL_TEXTUREACCESS_STATIC
		data = SDL createTexture (vamos renderer, fmt, access, width, height)
	}
	
	assertRendererExists: func {
		if (!vamos || !vamos renderer)
			raise("Can't create texture when engine is not initialised!")
	}
	
	color: Color {
		get
		set (v) {
			color = v
			SDL setTextureColorMod(data, v r, v g, v b)
			SDL setTextureAlphaMod(data, v a)
		}
	}
	color = (255,255,255,255) as Color
	
	blend: BlendMode {
		get
		set (v) {
			blend = v
			SDL setTextureBlendMode(data, v as Int)
		}
	}
	blend = BlendMode BLEND
	
	copyPixels: func (bitmap:Bitmap, sourceRect:SdlRect*, x, y:Int16) {
		pitch := bitmap pitch
		pixels := bitmap pixels + x + y*pitch/4
		SDL updateTexture(data, sourceRect, pixels, pitch)
	}

	copyPixels: func~separate (bitmap:Bitmap, sx, sy:Int16, sw, sh:UInt16, x, y:Int16) {
		copyPixels(bitmap, ((sx,sy,sw,sh) as SdlRect)&, x, y)
	}

	copyPixels: func~sameDest (bitmap:Bitmap, x, y:Int16, w, h:UInt16) {
		copyPixels(bitmap, ((x,y,w,h) as SdlRect)&, x, y)
	}

	copyPixels: func~sameDestRect (bitmap:Bitmap, rect:SdlRect*) {
		copyPixels(bitmap, rect, rect@ x, rect@ y)
	}

	copyPixels: func~whole (bitmap:Bitmap) {
		SDL updateTexture(data, ((0,0,bitmap width,bitmap height) as SdlRect)&, bitmap pixels, bitmap pitch)
	}
	
	free: func {
		SDL destroyTexture(data)
		width = 0
		height = 0
	}
	
}
