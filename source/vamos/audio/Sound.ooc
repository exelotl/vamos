use sdl2
import sdl2/Audio
import vamos/[Engine, AssetCache, Signal]
import vamos/audio/[Sample, Mixer, AudioSource]

/**
 * Can load sound from a .wav or .ogg file
 * If your file is large, consider using a streaming 'Music' object instead.
 */
Sound: class extends AudioSource {
	
	sample: Sample
	position: UInt32
	
	playing := false
	looping := false
	volume: Double = 1
	pan: Double = 0
	onComplete := VoidSignal new()
	
	init: func (key:String) {
		sample = vamos assets getSample(key)
	}
	
	play: func (restart := true) {
		if (restart) position = 0
		playing = true
		if (!mixer) addSelf()
	}
	//play: func {
	//	play(volume, pan)
	//}
	//
	//play: func ~withVolumeAndPan (volume, pan: Double) {
	//	// play the sound with the arguments
	//	if (playing) stop()
	//	position = 0
	//}
	
	complete: func {
		stop()
		removeSelf()
	}
	
	stop: func {
		pause()
		position = 0
	}
	
	pause: func {
		playing = false
	}
	
	resume: func {
		playing = true
	}
	
	mixInto: func (stream:UInt8*, len:Int) {
		if (playing) {
			remaining := sample size - position
			if (remaining == 0) {
				complete()
				return
			}
			if (remaining < len) len = remaining
			
			SdlAudio mix(stream, sample data[position]&, len, volume*SDL_MIX_MAXVOLUME)
			position += len
		}
	}
}