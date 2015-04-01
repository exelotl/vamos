use sdl2
import sdl2/Core

Color: cover {
	a:UInt8 = 255
	r,g,b:UInt8
	
	/// Sets each channel separately
	set: func@ ~separate (_a, _r, _g, _b:UInt8) {
		(a,r,g,b) = (_a,_r,_g,_b)
	}
	
	/// Sets each channel based on values from 0 to 1
	set: func@ ~fractions (_a, _r, _g, _b:Float) {
		(a,r,g,b) = (_a*255,_r*255,_g*255,_b*255)
	}
	
	/// Sets each channel based on a 32 bit color in 0xaarrggbb format
	set: func@ ~combined (argb:UInt32) {
		a = argb >> 24
		r = (argb >> 16) & 0xff
		g = (argb >> 8) & 0xff
		b = argb & 0xff 
	}
	
	/// Sets each channel using a string in #rrggbb or #aarrggbb format
	set: func@ ~string (str:String) {
		this set(str replaceAll("#", "") toULong(16))
		if (str size < 8) a = 255
	}
	
	set: func@ ~sdl (pixel:UInt32, format:SdlPixelFormat*) {
		SDL getRgba(pixel, format, r&, g&, b&, a&)
	}
	
	toSDL: func (format:SdlPixelFormat*) -> UInt32 {
		SDL mapRgba(format, r, g, b, a)
	}
	
	/// Returns a 32-bit 0xaarrggbb version of the color
	toArgb: func@ -> UInt32 {
		(a << 24) & (r << 16) & (g << 8) & b
	}
	
	/// Returns the color as a string in #aarrggbb format
	toString: func@ -> String {
		"#%x" format(toArgb())
	}
}

// These are the only blend modes supported by SDL currently.

BlendMode: enum {
	NONE  : extern (SDL_BLENDMODE_NONE)
	BLEND : extern (SDL_BLENDMODE_BLEND)
	ADD   : extern (SDL_BLENDMODE_ADD)
	MOD   : extern (SDL_BLENDMODE_MOD)
}
