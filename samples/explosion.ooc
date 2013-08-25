/*
 * Vamos - Explosion Minigame
 * Arrow keys to move, survive as long as possible
 * Space to restart!
 *
 * This sample demonstrates:
 *  - Creating a window with a caption
 *  - Creating a scene and filling it with entities
 *  - Handling keyboard input
 *  - Basic hitbox collision
 *  - Using a Component class to share behaviour between entities
 */

use vamos
import vamos/[Engine, Scene, Entity, Component, Input]
import vamos/graphics/[FilledRect, Label]
import vamos/masks/Hitbox
import math/Random

SCREEN_W := const 800
SCREEN_H := const 480

main: func (argc:Int, argv:CString*) {
	// create the window
	vamos = Engine new(SCREEN_W, SCREEN_H)
	vamos caption = "Explosion!"
	
	// start the main loop
	vamos start(PlayScene new())
}

PlayScene: class extends Scene {
	
	speed:Double = 1
	score:Double = 0
	label: Label = Label new("font.png", 6, 10, "")
	running := true
	
	create: func {
		add(Player new(40, 40))
		for (i in 0..100) add(Enemy new(390, 240))
		addGraphic(label, 2, 2)
		on("game_over", ||
			running = false
			speed = 0.4
			label text = "Game Over!\nYou scored: %.2f\nPress SPACE to restart." format(score)
		)
	}
	
	update: func (dt:Double) {
		super(dt*speed)
		if (running) {
			score += dt
			label set(score toString())
		} else if (Input pressed("space")) {
			vamos scene = PlayScene new()
		}
		if (Input pressed("escape"))
			vamos quit()
	}
	
}

Player: class extends Entity {
	
	speed:Double = 200.0
	
	init: func (=x, =y) {
		mask = Hitbox new(10, 10)
		graphic = FilledRect new(10, 10, 0xffffffff)
		type = "player"
		add(Wrapping new())
	}
	
	update: func (dt:Double) {
		if (Input held("up"))    y -= speed * dt
		if (Input held("down"))  y += speed * dt
		if (Input held("left"))  x -= speed * dt
		if (Input held("right")) x += speed * dt
		if (collide("enemy")) {
			broadcast("game_over")
			scene remove(this)
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
		add(Wrapping new())
	}
	
	update: func (dt:Double) {
		x += velX * dt
		y += velY * dt
	}
}

// Reusable behaviour, move entities to the other side when they cross the edge of the screen.

Wrapping: class extends Component {
	box:Hitbox
	added: func {
		box = entity mask as Hitbox
	}
	update: func (dt:Double) {
		if (entity x < -box width) entity x = SCREEN_W
		if (entity x > SCREEN_W) entity x = -box width
		if (entity y < -box width) entity y = SCREEN_H
		if (entity y > SCREEN_H) entity y = -box width
	}
}