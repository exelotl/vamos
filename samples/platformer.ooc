use vamos
import vamos/[Engine, Scene, Entity, Component, Input, Util]
import vamos/graphics/[TileMap, Anim]
import vamos/masks/[Hitbox, Grid]
import vamos/comps/Physics
import vamos/display/[Screen, Color]

SCREEN_W := const 200
SCREEN_H := const 120

map := [
	1,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14, 3,
	8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8,
	8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8,
	8, 0, 0, 0, 0,13,14,15, 0, 0, 0, 0, 0, 0, 0, 0, 8,
	8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8,
	8, 0,13,14,15, 0, 0, 0, 0, 0, 0,13,14,15, 0, 0, 8,
	8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8,
	8, 0, 0, 0, 0, 0, 0,13,14,15, 0, 0, 0, 0, 0, 0, 8,
	8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 8,
	9,14,14,14,14,14,14,14,14,14,14,14,14,14, 6,14,11]

main: func (argc:Int, argv:CString*) {
	vamos = Engine new(SCREEN_W, SCREEN_H, 3)
	vamos caption = "Platformer"
	vamos start(PlayScene new())
}

PlayScene: class extends Scene {
	
	player:Player
	
	create: func {
		vamos screen color set("#cc7777")
		
		tiles := TileMap new("tiles.png", 17, 10, 12,12)
		tiles data = map data
		grid := Grid new(17, 10, 12,12)
		grid data = map data
		
		walls := Entity new(-2, 0, tiles, grid)
		walls type = "walls"
		add(walls)
		
		add(player = Player new(14, 14))
	}
}

Player: class extends Entity {
	
	physics: Physics
	
	onFloor: Bool
	moving: Bool
	facing: Char
	
	init: func (=x, =y) {
		mask = Hitbox new(6, 8)
		
		physics = Physics new(["walls"])
		physics accY = 700
		physics dragX = 1000
		physics maxVelX = 160
		physics maxVelY = 400
		add(physics)
		add(PlayerInput new())
		graphic = PlayerAnim new(this)
	}
	
	update: func (dt:Double) {
		onFloor = collide("walls", x, y+1)
	}
	
	idle: func {
		physics accX = 0
		moving = false
	}
	runLeft: func {
		physics accX = -1000
		moving = true
		facing = 'l'
	}
	runRight: func {
		physics accX = 1000
		moving = true
		facing = 'r'
	}
	jump: func {
		physics velY = -200
	}
}

PlayerAnim: class extends Anim {
	
	RUN_R := static const [1,1,2,0,2]
	RUN_L := static const [4,4,5,3,5]
	player: Player
	
	init: func (=player) {
		super("player.png", 12, 12)
		position(-3, -3)
	}
	update: func (dt:Float) {
		if (player onFloor) {
			if (player physics velX > 50) play(RUN_R, 30)
			else if (player physics velX < -50) play(RUN_L, 30)
			else stop(player facing == 'r' ? 0 : 3)
		} else {
			stop(player facing == 'r' ? 1 : 4)
		}
		super(dt)
	}
}

PlayerInput: class extends Component {
	player: Player
	
	added: func {
		player = entity as Player
	}
	update: func (dt:Float) {
		if (Input pressed("left")) player runLeft()
		if (Input pressed("right")) player runRight()
		
		if (Input released("left")) {
			if (Input held("right")) player runRight()
			else player idle()
		}
		if (Input released("right")) {
			if (Input held("left")) player runLeft()
			else player idle()
		}
		
		if (Input pressed("up") && player onFloor) player jump()
	}
}
