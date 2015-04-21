import vamos/Engine
import vamos/audio/Mixer
import threading/Thread

/**
 * Base class for anything that can produce sound, that can be added to the mixer
 */
AudioSource: abstract class {
	
	mixer: Mixer
	
	_mutex := Mutex new()
	
	// use for reliable access to the properties of this source
	lock: func { _mutex lock() }
	unlock: func { _mutex unlock() }
	
	// Mix sound into an audio stream.
	// Don't remove or instantiate anything in here
	//  doing so could mess up the GC/threads (sorry. D:)
	mixInto: abstract func (buffer:UInt8*, len:Int)
	
	// Called when added/removed from the mixer
	added: func
	removed: func
	
	// Do whatever you like in here!
	update: func (dt:Float)
	
	addSelf: func {
		vamos mixer add(this)
	}
	removeSelf: func {
		vamos mixer remove(this)
	}
	
	_removed := false
	
}