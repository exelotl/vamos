use sdl2
import sdl2/[Core, Audio]
import ./Sample

SampleLoader: class {
	
	load: static func (path:String, spec:SdlAudioSpec) -> Sample {
		match {
			case path endsWith?(".wav") => loadWav(path, spec)
			case => null
		}
	}
	
	loadWav: static func (path:String, spec:SdlAudioSpec) -> Sample {
		wav: SdlAudioSpec
		data: UInt8*
		size: UInt32
		
		if (SdlAudio loadWAV(path, wav&, data&, size&) == null) {
			raise("Error loading wav: %s" format(SDL getError()))
		}
		
		converter: SdlAudioConverter
		SdlAudio buildConverter(
			converter&,
			wav format,
			wav channels,
			wav freq,
			spec format,
			spec channels,
			spec freq)
		
		converter len = size
		converter buf = gc_malloc(size * converter len_mult)
		memcpy(converter buf, data, size)
		
		SdlAudio convert(converter&)
		SdlAudio freeWAV(data)
		
		return Sample new(converter buf, converter len)
	}
	
}