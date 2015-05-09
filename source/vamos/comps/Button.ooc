import vamos/[Component, Entity, Input]

Button: class extends Component {
	name = "button"
	
	width, height: Int
	xOffset, yOffset: Int
	
	onMouseEnter: func(=_mouseEnter)
	onMouseLeave: func(=_mouseLeave)
	onClick: func(=_click)
	onRelease: func(=_release)
	
	init: func(=width, =height)
	
	update: func(dt: Float) {
		if ((Input mouseX - entity x - xOffset) in?(0..width) && 
			(Input mouseY - entity y - yOffset) in?(0..height)) {
			if (!_mouseOver?) {
				_mouseEnter()
				_mouseOver? = true
			}
			if (Input mousePressed()) {
				_click()
				_clicked? = true
			}
		} else {
			if (_mouseOver?) {
				_mouseLeave()
				_mouseOver? = false
			}
		}
		if (_clicked? && Input mouseReleased()) {
			_release()
			_clicked? = false
		}
	}
	
	_mouseEnter: Func = func {}
	_mouseLeave: Func = func {}
	_click: Func = func {}
	_release: Func = func {}
	_mouseOver? := false
	_clicked? := false
}