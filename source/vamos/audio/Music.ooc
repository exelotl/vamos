use stb-vorbis, sdl2
import sdl2/Audio
import vamos/audio/[Mixer, AudioSource]

/**
 * Uses stb_vorbis to stream an a .ogg file
 * (doesn't work with mp3 or other formats)
 */
Music: class extends AudioSource {
	
	error: StbVorbisError
	ogg: StbVorbis
	buffer: Short*
	playing := false
	
	init: func(filename:String) {
		ogg = StbVorbis openFilename(filename, error&, null)
		if (ogg == null)
			raise("Error in StbVorbis: " + error toString())
		playing = true
	}
	
	added: func {
		buffer = gc_malloc(mixer spec size)
	}
	
	removed: func {
		
	}
	
	mixInto: func (stream:UInt8*, len:Int) {
		if (playing) {
			ogg getSamplesInterleaved(2, buffer, len/2)	
			SdlAudio mix(stream, buffer, len, SDL_MIX_MAXVOLUME)
			
			if (ogg getSampleOffset() == ogg getLengthInSamples())
				playing = false
		}
	}
	
	update: func (dt:Double) {
		
	}
}
