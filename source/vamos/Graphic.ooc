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
	
	hide: func {
		visible = false
	}
	
	show: func {
		visible = true
	}
	
	fix: func {
		scrollX = 0
		scrollY = 0
	}
	
	position: inline func (x, y:Float) {
		this x = x
		this y = y
	}
}