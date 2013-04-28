import vamos/Entity
import vamos/display/Screen

Graphic: abstract class {
	
	visible := true
	active := true
	x, y: Double
	scrollX: Double = 1.0
	scrollY: Double = 1.0
	
	update: func (dt: Double)
	draw: abstract func (screen:Screen, entity:Entity, x, y: Double)
	
	assign: func (e:Entity) {
		e graphic = this
	}
	
	position: inline func (x, y:Double) {
		this x = x
		this y = y
	}
}