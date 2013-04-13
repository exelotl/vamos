/*
 * Vamos - Explosion Minigame
 * Arrow keys to move, survive as long as possible
 * Space to restart!
 *
 * This sample demonstrates:
 *  - Creating a window with a caption
 *  - Creating a state and filling it with entities
 *  - Handling keyboard input
 *  - Basic hitbox collision
 *  - Using a Component class to share behaviour between entities
 */

use vamos
import vamos/[Engine, State, Entity, Component, Input]
import vamos/graphics/FilledRect
import vamos/masks/Hitbox
import math/Random

SCREEN_W := const 800
SCREEN_H := const 480

main: func (argc:Int, argv:CString*) {
	engine := Engine new(SCREEN_W, SCREEN_H)
	engine start(PlayState new())
}

PlayState: class extends State {
	create: func {
		engine caption = "Explosion!"
		add(Player new(40, 40))
		for (i in 0..100) add(Enemy new(390, 240))
	}
	
	update: func (dt:Double) {
		super(dt)
		if (Input pressed("space"))
			engine state = PlayState new()
	}
}

Player: class extends Entity {
	
	speed:Double = 200.0
	
	init: func (=x, =y) {
		mask = Hitbox new(10, 10)
		graphic = FilledRect new(10, 10, 0xffffffff)
		type = "player"
		addComp(Wrapping new())
	}
	
	update: func (dt:Double) {
		if (Input held("up"))    y -= speed * dt
		if (Input held("down"))  y += speed * dt
		if (Input held("left"))  x -= speed * dt
		if (Input held("right")) x += speed * dt
		if (collide("enemy")) {
			state remove(this)
			engine caption = "PRESS SPACE TO RESTART"
		}
	}
}

Enemy: class extends Entity {
	velX, velY: Double
	
	init: func (=x, =y) {
		size := Random randInt(10, 30)
		mask = Hitbox new(size, size)
		graphic = FilledRect new(size, size, 0xffff0000 + Random randInt(0, 0x2222))
		type = "enemy"
		
		velX = Random randInt(-100, 100)
		velY = Random randInt(-100, 100)
		addComp(Wrapping new())
	}
	
	update: func (dt:Double) {
		x += velX * dt
		y += velY * dt
	}
}

// Reusable behaviour, move entities to the other side when they cross the edge of the screen.

Wrapping: class extends Component {
	init: func
	update: func (dt:Double) {
		if (entity x < -20) entity x = SCREEN_W
		if (entity x > SCREEN_W) entity x = -20
		if (entity y < -20) entity y = SCREEN_H
		if (entity y > SCREEN_H) entity y = -20
	}
}