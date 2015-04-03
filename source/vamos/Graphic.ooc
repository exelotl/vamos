import vamos/Entity
import vamos/display/Screen

Graphic: abstract class {
	
	visible := true
	active := true
	x, y: Float
	scrollX := 1.0f
	scrollY := 1.0f
	
	update: func (dt: Float)
	draw: abstract func (screen:Screen, entity:Entity, x, y: Float)
	
	assign: func (e:Entity) {
		e graphic = this
	}
	
	position: inline func (x, y:Float) {
		this x = x
		this y = y
	}
}