use vamos
import vamos/[Engine, Scene, Entity, Component, Input, Util]
import vamos/graphics/[TileMap, Anim]
import vamos/masks/[Hitbox, Grid]
import vamos/comps/Physics
import vamos/display/Color

mapData := [
	1,1,1,1,1,1,1,1,1,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,0,0,0,1,1,1,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,0,1,1,1,0,0,0,0,1,
	1,0,0,0,0,0,0,0,0,1,
	1,1,1,1,1,1,1,1,1,1]

main: func (argc:Int, argv:CString*) {
	vamos = Engine new(400, 240, 1)
	vamos start(PlayScene new())
}

PlayScene: class extends Scene {
	create: func {
		color set("#cccccc")
		add(Player new(14, 14))
		
		tilemap := TileMap new("tiles.png", 10, 8, 12,12)
		tilemap data = mapData data
		grid := Grid new(10, 8, 12,12)
		grid data = mapData data
		
		map := Entity new(0, 0, tilemap, grid)
		map type = "walls"
		add(map)
	}
}

Player: class extends Entity {
	
	physics: Physics
	
	init: func (=x, =y) {
		mask = Hitbox new(10, 10)
		graphic = PlayerAnim new(this)
		
		physics = Physics new(["walls"])
		physics accY = 500
		physics dragX = 1000
		physics maxVelX = 200
		physics maxVelY = 400
		add(physics)
		add(PlayerInput new())
	}
	
	update: func (dt:Double) {
		
	}
	
	idle: func {
		physics accX = 0
	}
	runLeft: func {
		physics accX = -1000
	}
	runRight: func {
		physics accX = 1000
	}
	jump: func {
		physics velY = -200
	}
}

PlayerAnim: class extends Anim {
	
	RUN_R := static const [0,1,2,1]
	RUN_L := static const [3,4,5,4]
	player: Player
	
	init: func (=player) {
		super("player.png", 12, 12)
		//position(1, 2)
	}
	update: func (dt:Double) {
		velX := player get(Physics) velX
		if (velX > 0) play(RUN_R, 30)
		else if (velX < 0) play(RUN_L, 30)
	}
}

PlayerInput: class extends Component {
	player: Player
	
	added: func {
		player = entity as Player
	}
	update: func (dt:Double) {
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
		
		if (Input pressed("up")) player jump()
	}
}
