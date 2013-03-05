use sdl2
import sdl2/Core

use stb-image
import stb/image

SurfaceLoader: class {
	
	load: static func(path:String) -> SdlSurface* {
		
		width, height, channels: Int
		(r,g,b,a) := getChannelMasks()
		
		data := StbImage fromPath(path, width&, height&, channels&, 0)
		
		
		surface:SdlSurface*
		
		if (channels == 4) {
			surface = SDL createRGBSurface(0, width, height, 32, r,g,b,a)
		} else if (channels == 3) {
			surface = SDL createRGBSurface(0, width, height, 24, r,g,b,0)
		} else {
			free(data)
			return null
		}
		
		memcpy(surface@ pixels, data, width*height*channels)
		free(data)
		
		return surface
	}
	
	getChannelMasks: static func -> (UInt32,UInt32,UInt32,UInt32) {
		r,g,b,a : UInt32
		
		if (SDL_BYTEORDER == SDL_BIG_ENDIAN) {
			r = 0xff000000
			g = 0x00ff0000
			b = 0x0000ff00
			a = 0x000000ff
		} else {
			r = 0x000000ff
			g = 0x0000ff00
			b = 0x00ff0000
			a = 0xff000000
		}
		return (r,g,b,a)
	}
	
}
