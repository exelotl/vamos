use stb-vorbis, sdl2
import sdl2/Audio
import vamos/Util
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
	loop := true
	
	volume := 1.0
	_volChange := 0.0 // per audio frame (used for fading in/out)
	
	init: func(filename:String) {
		ogg = StbVorbis openFilename(filename, error&, null)
		if (ogg == null)
			raise("Error in StbVorbis: " + error toString())
	}
	
	added: func {
		buffer = gc_malloc(mixer spec size)
	}
	
	removed: func {
		
	}
	
	play: func {
		if (!mixer) addSelf()
		playing = true
	}
	pause: func {
		playing = false
	}
	stop: func {
		ogg seekStart()
		playing = false
	}
	
	fadeIn: func (t:Float) {
		_volChange = 1.0 / (t * mixer sampleRate as Float)
	}
	fadeOut: func (t:Float) {
		_volChange = -1.0 / (t * mixer sampleRate as Float)
	}
	
	mixInto: func (stream:UInt8*, len:Int) {
		
		if (playing) {
			
			ogg getSamplesInterleaved(2, buffer, len/2)
			
			for (i in 0..len/2) {
				volume = (volume + _volChange) clamp(0, 1)
				buffer[i] = (buffer[i] as Float) * volume
			} 
			
			SdlAudio mix(stream, buffer, len, SDL_MIX_MAXVOLUME)
			
			if (ogg getSampleOffset() == ogg getLengthInSamples()) {
				if (loop) ogg seekStart()
				else playing = false
			}
		}
	}
	
	update: func (dt:Float) {
		
	}
}
