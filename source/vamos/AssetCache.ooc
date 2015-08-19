import io/File
use sdl2
import sdl2/Core
import structs/HashMap
import vamos/Engine
import vamos/display/[Texture, Bitmap]
import vamos/audio/Sample

AssetCache: class {
	
	engine: Engine
	textureCache := HashMap<String, Texture> new()
	bitmapCache := HashMap<String, Bitmap> new()
	sampleCache := HashMap<String, Sample> new()
	
	init: func (=engine)
	
	/**
	 * Clean up everything, including assets that weren't created by the cache itself.
	 * Will be called automatically when the engine quits.
	 */
	free: func {
		for (texture in textureCache) texture free()
		textureCache clear()
		for (bitmap in bitmapCache) bitmap free()
		bitmapCache clear()
		sampleCache clear()
	}
	
	/**
	 * Retrieve a texture from a path (relative to the assets folder), or from a manually assigned key.
	 */
	getTexture: func (key:String) -> Texture {
		if (engine renderer == null)
			raise("Can't obtain textures when the renderer is not initialised!")
		
		texture:Texture = textureCache[key]
		
		if (texture == null) {
			key = "assets/" + key
			texture = textureCache[key]
		}
		if (texture == null) {
			texture = Texture new(key)
			register(key, texture)
		}
		return texture
	}
	
	
	/**
	 * Retrieve a bitmap from a path (relative to the assets folder), or from a manually assigned key.
	 */
	getBitmap: func (key:String) -> Bitmap {
		if (engine == null)
			raise("Can't obtain bitmaps when the engine is not active!")
		
		bitmap:Bitmap = bitmapCache[key]
		
		if (bitmap == null) {
			key = "assets/" + key
			bitmap = bitmapCache[key]
		}
		if (bitmap == null) {
			bitmap = Bitmap new(key)
			register(key, bitmap)
		}
		return bitmap
	}
	
	getSample: func (key:String) -> Sample {
		if (engine == null)
			raise("Can't obtain samples when the engine is not active!")
		
		sample:Sample = sampleCache[key]
		
		if (sample == null) {
			key = "assets/" + key
			sample = sampleCache[key]
		}
		if (sample == null) {
			sample = Sample create(key, engine mixer)
			register(key, sample)
		}
		return sample
	}
	
	
	register: func ~texture (key:String, texture:Texture) {
		textureCache[key] = texture
	}
	register: func ~bitmap (key:String, bitmap:Bitmap) {
		bitmapCache[key] = bitmap
	}
	register: func ~samples (key:String, sample:Sample) {
		sampleCache[key] = sample
	}
}