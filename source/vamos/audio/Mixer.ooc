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
	
	open? : Bool {
		get { _currentSources == sources }
	}
	
	sampleRate: Int {
		get { spec freq }
	}
	
	init: func {
		spec freq = 44100
		spec format = AUDIO_S16
		spec channels = 2
		spec samples = 1024
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
		if (open?) _currentSources = null
		SdlAudio close()
	}
	
	/// If this causes threading problems it might need to be changed or removed
	update: func(dt:Float) {
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
		if (!open?) open()
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

_mix: func (userdata:Pointer, stream:UInt8*, len:Int) {
	
	// clear the audio buffer
	memset(stream, 0, len)
	
	/*
		WARNING - On some platforms SDL and ooc's garbage collector may use different thread libraries.
		          For this reason, the mixInto methods should not allocate any garbage-collected memory!
		          That includes instantiating objects, creating iterators (using the for loop) etc.
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
