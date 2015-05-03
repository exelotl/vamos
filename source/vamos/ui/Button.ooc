import vamos/[Entity, Input]

Button: class extends Entity {
    width, height: Int
        
    mouseEnter: func
    mouseLeave: func
    click: func
	release: func
    
    _mouseOver? := false
    _clicked? := false
    
    init: func
    init: func ~pos(=x, =y)
    init: func ~area(=x, =y, =width, =height)
    
    update: func(dt: Float) {
        mX := Input mouseX
        mY := Input mouseY
        if (mX >= x && mX < x + width && mY >= y && mY < y + height) {
            if (!_mouseOver?) {
                mouseEnter()
				_mouseOver? = true
            }
            if (Input mousePressed) {
                click()
            }
        } else {
            if (_mouseOver?) {
                mouseLeave()
				_mouseOver? = false
            }
        }
		if (_clicked? && Input mouseReleased) {
			release()
			_clicked? = false
		}
    }
}