use sdl2
import sdl2/Core
import vamos/[Util, Input, AssetCache, Scene, SceneManager]
import vamos/display/[SceneRenderer, Bitmap]
import vamos/audio/Mixer

engine:Engine

/**
 * Manages the various subsystems, runs the main loop
 */
Engine: class {
	
	running := false
	width, height: Int
	scale:UInt
	frameRate:Double
	dt:Double
	
	window: SdlWindow
	renderer: SdlRenderer
	assets: AssetCache
	mixer: Mixer
	sceneManager: SceneManager
	sceneRenderer: SceneRenderer
	scene: Scene {
		get { sceneManager scene }
		set (s) {
			sceneManager scene = s
			sceneRenderer scene = s
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
	
	init: func (=width, =height, =scale, =frameRate) {
		
		if (engine)
			raise("Only one engine can exist at a time!")
		
		SDL init(SDL_INIT_EVERYTHING)
		
		window = SDL createWindow(
			"Vamos",
			SDL_WINDOWPOS_UNDEFINED,
			SDL_WINDOWPOS_UNDEFINED,
			width*scale, height*scale, SDL_WINDOW_SHOWN)
		
		renderer = SDL createRenderer(window, -1, SDL_RENDERER_ACCELERATED)
		SDL renderSetLogicalSize(renderer, width, height)
		
		engine = this
		
		assets = AssetCache new(this)
		mixer = Mixer new() .open()
		sceneManager = SceneManager new()
		sceneRenderer = SceneRenderer new(window, renderer)
	}
	
	init: func ~defaultFramerate (.width, .height, .scale) {
		init(width, height, frameRate, 1)
	}
	init: func ~defaultScale (.width, .height) {
		init(width, height, 1, 60)
	}
	
	
	start: func (scene:Scene) {
		this scene = scene
		
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
		sceneManager update(dt)
		sceneRenderer draw()
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
