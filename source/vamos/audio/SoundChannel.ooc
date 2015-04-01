import vamos/audio/Sound

SoundChannel: class extends Sound {

	sounds := ArrayList<Sound> new()
	
	init: func (=sounds) {}
	init: func ~withVolumeAndPan (=sounds, =volume, =pan) {}
	
	play: func ~withVolumeAndPan (volume, pan: Float) {
		if (playing) stop()
		position = 0.0
		for (sound in sounds) sound play(volume, pan)
		playing = true
	}
	
	stop: func () {
		if (!playing) return
		for (sound in sounds) sound stop()
		position = 0.0
		playing = false
	}
	
	pause: func () {
		if (!playing) return
		for (sound in sounds) sound pause()
		playing = false
	}
	
	resume: func () {
		if (playing) return
		for (sound in sounds) sound resume()
	}
	
	addSound: func (sound: Sound) {
		sounds add(sound)
		sound playing = playing
		sound looping = looping
		if (playing) {
			sound play(looping)
		}
	}
	
	removeSound: func (sound: Sound) {
		sound stop()
		sounds remove(sound)
	}
}