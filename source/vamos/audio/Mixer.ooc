use sdl2
import sdl2/[Core, Audio]
import structs/ArrayList
import vamos/audio/AudioSource

/**
 * Contains sound sources, streams them to SDL on-demand.
 * Generally one instance exists per game, managed by the engine.
 */
Mixer: class {
	
	sources := ArrayList<AudioSource> new()
	spec: SdlAudioSpec
	
	init: func {
		spec freq = 44100
		spec format = AUDIO_S16
		spec channels = 2
		spec samples = 512
		spec callback = _mix
	}
	
	/// Make SDL use this mixer's spec. Begin playing audio.
	open: func {
		_currentSources = sources
		if (SdlAudio open(spec&, null) < 0) {
			raise("SDL failed to open audio driver: %s" format(SDL getError()))
		}
		play()
	}
	
	close: func {
		if (_currentSources == sources)
			_currentSources = null
		SdlAudio close()
	}
	
	/// If this causes threading problems it might need to be changed or removed
	update: func(dt:Double) {
		iter := sources iterator()
		while (iter hasNext?()) {
			source := iter next()
			if (source _removed) {
				source mixer = null
				iter remove()
			}
			else source update(dt)
		}
	}
	
	add: func (source:AudioSource) {
		sources add(source)
		source mixer = this
		source added()
	}
	remove: func (source:AudioSource) {
		source _removed = true
		source removed()
	}
	
	play: func {
		SdlAudio setPaused(false)
	}
	
	pause: func {
		SdlAudio setPaused(true)
	}
}


_currentSources: static ArrayList<AudioSource>

_mix: static func (userdata:Pointer, stream:UInt8*, len:Int) {
	
	// clear the audio buffer
	memset(stream, 0, len)
	
	/*
		WARNING - Due to differences in SDL and Boehm GC threads,
		          the garbage collector must *not* be invoked in any
		          mix or mixInto callbacks!
		          Hopefully this will be fixed, but the current
		          workaround is to not instantiate any objects in here.
	*/
	if (_currentSources == null)
		return
	
	i := 0
	while (i < _currentSources size) {
		source := _currentSources[i]
		source mixInto(stream, len)
		i += 1
	}
}
