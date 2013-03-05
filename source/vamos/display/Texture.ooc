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
	width: Double
	height: Double
	
	init: func ~fromSurface (surface:SdlSurface*) {
		if (!engine || !engine renderer)
			raise("Can't create texture when engine is not initialised!")
		data = SDL createTextureFromSurface(engine renderer, surface)
		width = surface@ w
		height = surface@ h
	}
	
	init: func ~fromBitmap (bitmap:Bitmap) {
		init(bitmap surface)
	}
	
	init: func ~fromPath (path:String) {
		surface := SurfaceLoader load(path)
		if (surface == null) {
			"!! Error loading image '%s'" printfln(path)
			surface = SDL createRGBSurface(0, 8, 8, 32, 0,0,0,0) // init with placeholder 
		}
		init(surface)
		SDL freeSurface(surface)
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
	
	//alpha: UInt8 {
	//	get { SDL getTextureAlphaMod(data) }
	//	set (v) { SDL setTextureAlphaMod(data, v) }
	//}
	//
	//color: C
	
	free: func {
		SDL destroyTexture(data)
		width = 0
		height = 0
	}
	
}