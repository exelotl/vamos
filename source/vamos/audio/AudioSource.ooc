import vamos/Engine
import vamos/audio/Mixer

/**
 * Base class for anything that can produce sound, that can be added to the mixer
 */
AudioSource: abstract class {
	
	mixer: Mixer
	
	// Mix sound into an audio stream.
	// Don't remove or instantiate anything in here
	//  doing so could mess up the GC/threads (sorry. D:)
	mixInto: abstract func (buffer:UInt8*, len:Int)
	
	// Called when added/removed from the mixer
	added: func
	removed: func
	
	// Do whatever you like in here!
	update: func (dt:Double)
	
	addSelf: func {
		engine mixer add(this)
	}
	removeSelf: func {
		engine mixer remove(this)
	}
	
	_removed := false
	
}