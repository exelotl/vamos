import vamos/Entity
import vamos/display/SceneRenderer

Graphic: abstract class {
	
	visible := true
	active := true
	x, y: Double
	scrollX: Double = 1.0
	scrollY: Double = 1.0
	
	update: func (dt: Double)
	draw: abstract func (renderer: SceneRenderer, entity:Entity, x, y: Double)
}