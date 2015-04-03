use sdl2
import sdl2/Audio
import vamos/[Engine, Util, AssetCache]
import vamos/audio/[Sample, Mixer, AudioSource]

/**
 * Can load sound from a .wav or .ogg file
 * If your file is large, consider using a streaming 'Music' object instead.
 */
Sound: class extends AudioSource {
	
	sample: Sample
	position: UInt32
	
	playing := false
	looping := true
	volume := 1.0f
	pan := 0.0f
	
	init: func (key:String) {
		sample = vamos assets getSample(key)
	}
	
	play: func {
		playing = true
		if (!mixer) addSelf()
	}
	//play: func {
	//	play(volume, pan)
	//}
	//
	//play: func ~withVolumeAndPan (volume, pan: Float) {
	//	// play the sound with the arguments
	//	if (playing) stop()
	//	position = 0
	//}
	
	complete: func {
		stop()
		removeSelf()
	}
	
	stop: func {
		playing = false
		position = 0
	}
	
	pause: func {
		playing = false
	}
	
	resume: func {
		playing = true
	}
	
	
	// mixer callback stuff:
	
	mixInto: func (buffer:UInt8*, bufferSize:Int) {
		
		bufferPos := 0
		
		while (playing && bufferPos < bufferSize) {
			
			remaining := sample size - position
			len := min(remaining, bufferSize) - bufferPos
			
			if (remaining < len) len = remaining
			
			SdlAudio mix(buffer[bufferPos]&, sample data[position]&, len, volume*SDL_MIX_MAXVOLUME)
			position += len
			bufferPos += len
			
			if (position == sample size) {
				if (looping) position = 0
				else complete()
			}
		}
	}
	
	//_is
}