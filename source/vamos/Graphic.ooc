import vamos/Entity
import vamos/display/StateRenderer

Graphic: abstract class {
	
	visible := true
	active := true
	x, y: Double
	scrollX: Double = 1.0
	scrollY: Double = 1.0
	
	update: func (dt: Double)
	draw: abstract func (renderer: StateRenderer, entity:Entity, x, y: Double)
}