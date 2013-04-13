use sdl2
import sdl2/Core
import vamos/[Util, Input, AssetCache, State, StateManager]
import vamos/display/[StateRenderer, Bitmap]
import vamos/audio/Mixer

engine:Engine

/**
 * Manages the various subsystems, runs the main loop
 */
Engine: class {
	
	running := false
	width, height: Int
	frameRate:Double = 60
	dt:Double
	
	window: SdlWindow
	renderer: SdlRenderer
	assets: AssetCache
	mixer: Mixer
	stateManager: StateManager
	stateRenderer: StateRenderer
	state: State {
		get { stateManager state }
		set (s) {
			stateManager state = s
			stateRenderer state = s
		}
	}
	
	caption: String {
		get { SDL getWindowTitle(window) as String}
		set (v) { SDL setWindowTitle(window, v) }
	}
	fullscreen: Bool {
		get
		set (v) { SDL setWindowFullscreen(window, v) }
	}
	
	init: func (=width, =height, =frameRate) {
		
		if (engine)
			raise("Only one engine can exist at a time!")
		
		SDL init(SDL_INIT_EVERYTHING)
		
		window = SDL createWindow(
			"Vamos",
			SDL_WINDOWPOS_UNDEFINED,
			SDL_WINDOWPOS_UNDEFINED,
			width, height, SDL_WINDOW_SHOWN)
		
		renderer = SDL createRenderer(window, -1, SDL_RENDERER_ACCELERATED)
		
		engine = this
		
		assets = AssetCache new(this)
		mixer = Mixer new() .open()
		stateManager = StateManager new()
		stateRenderer = StateRenderer new(window, renderer)
	}
	
	
	start: func (state:State) {
		this state = state
		
		running = true
		Input onQuit add(|| running = false)
		
		while (running) {
			update()
		}
		
		cleanup()
	}
	
	update: func {
		startTime := time()
		
		Input update()
		stateManager update(dt)
		stateRenderer draw()
		mixer update(dt)
		
		sleep(1.0/frameRate - dt)
		dt = min(time()-startTime, 2.0/frameRate)
	}
	
	/// number of seconds since the program began
	time: func -> Double {
		SDL getTicks() as Double / 1000.0
	}
	
	/// Pause the program for the specified number of seconds
	sleep: func (seconds:Double) {
		if (seconds < 0) seconds = 0
		SDL delay(seconds*1000)
	}
	
	setIcon: func (bitmap:Bitmap) {
		SDL setWindowIcon(window, bitmap surface)
	}
	
	cleanup: func {
		mixer close()
		assets free()
		engine = null
		SDL destroyRenderer(renderer)
		SDL destroyWindow(window)
		SDL quit()
	}
}
