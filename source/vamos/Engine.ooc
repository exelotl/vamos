use sdl2
import sdl2/Core
import vamos/[Util, Input, AssetCache, Scene, SceneManager]
import vamos/display/[Screen, Bitmap]
import vamos/audio/Mixer

vamos:Engine

/**
 * Manages the various subsystems, runs the main loop
 */
Engine: class {
	
	running := false
	width, height: Int
	scale: UInt
	frameRate: Float
	dt: Float
    
	window: SdlWindow
	renderer: SdlRenderer
    monitor: SdlDisplayMode
	assets: AssetCache
	mixer: Mixer
	sceneManager: SceneManager
	screen: Screen
	scene: Scene {
		get { sceneManager scene }
		set (s) {
			sceneManager scene = s
			screen scene = s
		}
	}
	
	caption: String {
		get { SDL getWindowTitle(window) as String}
		set (v) { SDL setWindowTitle(window, v) }
	}
	fullscreen: Bool {
		get
		set (v) { SDL setWindowFullscreen(window, v ? SDL_WINDOW_FULLSCREEN_DESKTOP : 0) }
	}
	
	init: func (=width, =height, =scale, =frameRate) {
		
		if (vamos)
			raise("Only one engine can exist at a time!")
		
		SDL init(SDL_INIT_EVERYTHING)
		
		window = SDL createWindow(
			"Vamos",
			SDL_WINDOWPOS_UNDEFINED,
			SDL_WINDOWPOS_UNDEFINED,
			width*scale, height*scale, SDL_WINDOW_SHOWN)
		
		SDL getDesktopDisplayMode(0, monitor&)
		SDL setWindowDisplayMode(window, monitor&)
		
		renderer = SDL createRenderer(window, -1, SDL_RENDERER_ACCELERATED)
		SDL renderSetLogicalSize(renderer, width, height)
		
		vamos = this
		
		assets = AssetCache new(this)
		mixer = Mixer new()
		sceneManager = SceneManager new()
		screen = Screen new(window, renderer)
	}
	
	init: func ~defaultFramerate (.width, .height, .scale) {
		init(width, height, scale, 60)
	}
	init: func ~defaultScale (.width, .height) {
		init(width, height, 1, 60)
	}
	
	
	start: func (scene:Scene) {
		this scene = scene
		
		running = true
		Input onQuit = func { quit() }
		
		while (running) {
			update()
		}
		
		cleanup()
	}
	
	update: func {
		startTime := time()
		
		Input update()
		sceneManager update(dt)
		screen draw()
		mixer update(dt)
		
		sleep(1.0f/frameRate - dt)
		dt = min(time()-startTime, 2.0f/frameRate)
	}
	
	/// number of seconds since the program began
	time: func -> Float {
		SDL getTicks() as Float / 1000.0f
	}
	
	/// Pause the program for the specified number of seconds
	sleep: func (seconds:Float) {
		if (seconds < 0) seconds = 0
		SDL delay(seconds*1000)
	}
	
	setIcon: func (bitmap:Bitmap) {
		SDL setWindowIcon(window, bitmap surface)
	}
	
	quit: func {
		running = false
	}
	
	cleanup: func {
		mixer mutex lock()
		mixer close()
		assets free()
		vamos = null
		SDL destroyRenderer(renderer)
		SDL destroyWindow(window)
		SDL quit()
		mixer mutex unlock()
	}
}