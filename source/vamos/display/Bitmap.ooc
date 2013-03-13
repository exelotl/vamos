use sdl2
import sdl2/Core
import ./[SurfaceLoader, Color]

Bitmap: class {
	
	surface: SdlSurface*
	
	width: Int { get { surface@ w } }
	height: Int { get { surface@ h } }
	format: SdlPixelFormat* { get { surface@ format } }
	pixels: UInt32* { get { surface@ pixels } }
	
	init: func ~surface (=surface)
	
	init: func ~path (path:String) {
		surface = SurfaceLoader load(path)
		if (surface == null) {
			"!! Error loading surface '%s'" printfln(path)
			surface = SDL createRGBSurface(0, 8, 8, 32, 0,0,0,0) // init with placeholder 
		}
	}
	
	init: func ~empty (w, h:UInt8, alpha:=true) {
		
		(r,g,b,a) := SurfaceLoader getChannelMasks()
		
		if (alpha) init(SDL createRGBSurface(0, w, h, 32, r,g,b,a))
		else init(SDL createRGBSurface(0, w, h, 24, r,g,b,0))
	}
	
	clone: func -> This {
		Bitmap new(SDL convertSurface(surface, surface@ format, 0))
	}
	
	clear: func {
		SDL fillRect(surface, null, 0)
	}
	
	fill: func (color:Color) {
		SDL fillRect(surface, null, color toSDL(format))
	}
	
	fillRect: func (rect:SdlRect, color:Color) {
		SDL fillRect(surface, rect&, color toSDL(format))
	}
	
	fillRect: func~separate (x, y:Int16, w, h:UInt16, color:Color) {
		SDL fillRect(surface, ((x,y,w,h) as SdlRect)&, color toSDL(format))
	}
	
	filter: func (f:Func(Int16,Int16,Color)->Color) {
		color:Color
		pixel:UInt32*
		SDL lockSurface(surface)
		for (x in 0..width) {
			for (y in 0..height) {
				pixel = pixels[x%width + y*width]&
				color set(pixel@, format)
				pixel@ = f(x, y, color) toSDL(format)
			}
		}
		SDL unlockSurface(surface)
	}
	
	/**
	 * Destroy any resources used by this bitmap.
	 * No need to call manually, unless you didn't obtain the bitmap through the AssetCache
	 */
	free: func {
		SDL freeSurface(surface)
	}
	
}