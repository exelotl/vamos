import vamos/Scene

SceneManager: class {
	
	scene: Scene {
		get
		set (newScene) {
			if (scene != null) {
				scene leave(newScene)
			}
			if (!newScene created) {
				newScene create()
			}
			newScene enter(scene)
			scene = newScene
		}
	}
	
	init: func
	
	update: func (dt:Float) {
		if (scene) scene update(dt)
	}
}