use vamos, vorbis
import sdl2/Audio
import vamos/Util
import vamos/audio/[Mixer, AudioSource]
import vorbis

/**
 * Uses ooc-vorbis (libvorbisfile bindings) to stream a .ogg file
 * For now, assumes the ogg has the same sample rate as the mixer.
 */
Music: class extends AudioSource {
	
	ogg: OggFile
	buffer: Short*
	playing := false
	loop := true
	
	// master volume (remains the same regardless of fades)
	volume := 1.0f
	
	_gain := 1.0f
	_gainChange := 0.0f // per audio frame (used for fading in/out)
	
	init: func(filename:String) {
		ogg = OggFile new(filename)
	}
	
	added: func {
		buffer = gc_malloc(mixer spec size)
	}
	
	removed: func {
		
	}
	
	_time: Double
	time: Double {
		get { _time }
		set (v) {
			_time = v
			ogg timeSeek(v)
		}
	}
	
	duration: Double {
		get { ogg timeTotal() }
	}
	
	play: func {
		if (!mixer) addSelf()
		playing = true
	}
	pause: func {
		playing = false
	}
	stop: func {
		time = 0
		playing = false
	}
	
	mute: func {
		_gain = 0.0f
		_gainChange = 0.0f
	}
	unmute: func {
		_gain = 1.0f
		_gainChange = 0.0f
	}
	fadeIn: func (t:Float) {
		_gainChange = 1.0f / (t * mixer sampleRate as Float)
	}
	fadeOut: func (t:Float) {
		_gainChange = -1.0f / (t * mixer sampleRate as Float)
	}
	
	mixInto: func (stream:UInt8*, len:Int) {
		
		if (playing) {
			
			totalBytesRead := 0
			
			_time = ogg time()
			
			while (totalBytesRead < len) {
				
				totalSamplesRead := totalBytesRead / 2
				bytesRead := ogg read(buffer[totalSamplesRead]&, len - totalBytesRead)
				totalBytesRead += bytesRead
				
				if (bytesRead == 0) {
					if (loop) {
						ogg timeSeek(0)
						_time = 0
					} else {
						playing = false
						break
					}
				}
			}
			
			for (i in 0..len/2) {
				_gain = (_gain + _gainChange) clamp(0, volume)
				buffer[i] = (buffer[i] as Float) * _gain
			}
			
			SdlAudio mix(stream, buffer, len, SDL_MIX_MAXVOLUME)
			
		}
	}
	
	update: func (dt:Float) {
		_time += dt
		if (_time > duration) {
			if (loop) _time -= duration
			else _time = duration
		}
	}
}
