use sdl2
import sdl2/Core

Color: cover {
	r,g,b:UInt8
	a:UInt8 = 255
	
	/// Sets each channel separately
	set: func@ (_r, _g, _b, _a:UInt8) {
		(r,g,b,a) = (_r,_g,_b,_a)
	}
	
	/// Sets each channel based on a 32 bit color in 0xrrggbbaa format
	set: func@ ~combined (rgba:UInt32) {
		r = rgba >> 24
		g = (rgba >> 16) & 0xff
		b = (rgba >> 8) & 0xff
		a = rgba & 0xff
	}
	
	/// Sets each channel using a string in #rrggbb or #rrggbbaa format
	set: func@ ~string (str:String) {
		rgba := str replaceAll("#", "") toULong(16)
		if (str size < 8) this set((rgba << 8) | 0xff)
		else this set(rgba)
	}
	
	set: func@ ~sdl (pixel:UInt32, format:SdlPixelFormat*) {
		SDL getRgba(pixel, format, r&, g&, b&, a&)
	}
	
	toSDL: func (format:SdlPixelFormat*) -> UInt32 {
		SDL mapRgba(format, r, g, b, a)
	}
	
	/// Returns a 32-bit 0xrrggbbaa version of the color
	toRgba: func@ -> UInt32 {
		(r << 24) & (g << 16) & (b << 8) & a
	}
	
	/// Returns the color as a string in #rrggbbaa format
	toString: func@ -> String {
		"#%x" format(toRgba())
	}
}

// These are the only blend modes supported by SDL currently.

BlendMode: enum {
	NONE  : extern (SDL_BLENDMODE_NONE)
	BLEND : extern (SDL_BLENDMODE_BLEND)
	ADD   : extern (SDL_BLENDMODE_ADD)
	MOD   : extern (SDL_BLENDMODE_MOD)
}
