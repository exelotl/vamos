import vamos/Scene

SceneManager: class {
	
	scene: Scene {
		get
		set (newScene) {
			if (scene != null) {
				scene onLeave dispatch(newScene)
			}
			if (!newScene created) {
				newScene create()
			}
			newScene onEnter dispatch(scene)
			scene = newScene
		}
	}
	
	init: func
	
	update: func (dt:Double) {
		if (scene) scene update(dt)
	}
}