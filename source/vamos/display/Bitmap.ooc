use sdl2
import sdl2/Core
import vamos/Engine
import vamos/display/Screen
import ./[SurfaceLoader, Color]

Bitmap: class {
	
	surface: SdlSurface*
	
	width: Int { get { surface@ w } }
	height: Int { get { surface@ h } }
	format: SdlPixelFormat* { get { surface@ format } }
	pixels: UInt32* { get { surface@ pixels } }
	pitch: UInt16 { get { surface@ pitch } }
	
	init: func ~surface (=surface)
	
	init: func ~path (path:String) {
		surface = SurfaceLoader load(path)
		if (surface == null) {
			"!! Error loading surface '%s'" printfln(path)
			surface = SDL createRGBSurface(0, 8, 8, 32, 0,0,0,0) // init with placeholder 
		}
	}
	
	init: func ~empty (w, h:UInt8) {
		(r,g,b,a) := SurfaceLoader getChannelMasks()
		// TODO clean this up
		surface := SDL createRGBSurface(0, w, h, 32, r,g,b,a)
		newSurface := SDL convertSurfaceFormat(surface, vamos screen format, 0)
		SDL freeSurface(surface)
		init(newSurface)
	}
	
	clone: func -> This {
		Bitmap new(SDL convertSurface(surface, surface@ format, 0))
	}
	
	clear: func {
		SDL fillRect(surface, null, 0)
	}
	
	clearRect: func (rect:SdlRect*) {
		SDL fillRect(surface, rect, 0)
	}
	
	clearRect: func~separate (x, y:Int16, w, h:UInt16) {
		SDL fillRect(surface, ((x,y,w,h) as SdlRect)&, 0)
	}
	
	fill: func (color:Color) {
		SDL fillRect(surface, null, color toSDL(format))
	}
	
	fillRect: func (rect:SdlRect*, color:Color) {
		SDL fillRect(surface, rect, color toSDL(format))
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
	
	copyPixels: func (source:Bitmap, sourceRect:SdlRect*, destRect: SdlRect*) {
		SDL blitSurface(source surface, sourceRect, surface, destRect)
	}
	copyPixels: func~rectTo (source:Bitmap, sourceRect:SdlRect*, x, y:Int16) {
		SDL blitSurface(source surface, sourceRect, surface, ((x,y,0,0) as SdlRect)&)
	}
	copyPixels: func~separate (source:Bitmap, sx, sy:Int16, sw, sh:UInt16, x, y:Int16) {
		SDL blitSurface(source surface, ((sx,sy,sw,sh) as SdlRect)&, surface, ((x,y,0,0) as SdlRect)&)
	}
	copyPixels: func~sameDestRect (source:Bitmap, rect:SdlRect*) {
		SDL blitSurface(source surface, rect, surface, rect)
	}
	copyPixels: func~sameDest (source:Bitmap, x, y:Int16, w, h:UInt16) {
		SDL blitSurface(source surface, ((x,y,w,h) as SdlRect)&, surface, ((x,y,0,0) as SdlRect)&)
	}
	copyPixels: func~wholeTo (source:Bitmap, x, y:Int16) {
		SDL blitSurface(source surface, null, surface, ((x,y,0,0) as SdlRect)&)
	}
	copyPixels: func~whole (source:Bitmap) {
		SDL blitSurface(source surface, null, surface, null)
	}

	/**
	 * Destroy any resources used by this bitmap.
	 * No need to call manually, unless you didn't obtain the bitmap through the AssetCache
	 */
	free: func {
		SDL freeSurface(surface)
	}
	
}
