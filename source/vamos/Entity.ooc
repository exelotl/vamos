import structs/[ArrayList, List]
import vamos/[Scene, Component, Graphic, Mask]

Entity: class {
	
	x, y:Double
	
	scene: Scene
	graphic: Graphic
	components := ArrayList<Component> new()
	
	type: String {
		get
		set (t) {
			if (scene)  {
				scene _removeFromType(this)
				type = t
				scene _addToType(this)
			} else {
				type = t
			}
		}
	}
	type = ""
	
	mask: Mask {
		set (v) {
			mask = v
			mask entity = this
		}
		get { mask }
	}
	
	init: func
	init: func ~pos(=x, =y)
	init: func ~full(=x, =y, =graphic, =mask)
	
	update: func (dt:Double)
	
	updateGraphic: func (dt:Double) {
		if (graphic) graphic update(dt)
	}
	
	updateComps: func (dt:Double) {
		iter := components iterator()
		
		while (iter hasNext?()) {
			comp := iter next()
			if (comp entity != this) iter remove()
			else if (comp active) comp update(dt)
		}
	}
	
	add: func (comp:Component) {
		components remove(comp)
		components add(comp)
		comp entity = this
		comp added()
	}
	
	add: func ~withName (name:String, comp:Component) {
		comp name = name
		add(comp)
	}
	
	remove: func (comp:Component) {
		comp removed()
		comp entity = null
	}
	
	remove: func ~byName (name:String) {
		remove(get(name))
	}
	remove: func ~byClass (class:Class) {
		remove(get(class) as Component)
	}
	
	get: func ~byName (name:String) -> Component {
		for (comp in components)
			if (comp name == name)
				return comp
		null
	}
	
	get: func ~byClass <T> (T:Class) -> T {
		for (comp in components)
			if (comp class == T)
				return comp as T
		null
	}
	
	collide: func (type:String, x, y:Double) -> Entity {
		if (mask == null) return null
		list:List<Entity> = scene types get(type)
		if (list == null) return null
		
		(oldX, oldY) := (this x, this y)
		(this x, this y) = (x, y)
		
		e := collideList(list)
		
		(this x, this y) = (oldX, oldY)
		return e
	}
	
	collide: func ~noPos (type:String) -> Entity {
		if (mask == null) return null
		list:List<Entity> = scene types get(type)
		if (list == null) return null
		return collideList(list)
	}
	
	collide: func ~types (types:ArrayList<String>, x, y:Double) -> Entity {
		if (mask == null) return null
		(oldX, oldY) := (this x, this y)
		(this x, this y) = (x, y)
		
		e:Entity
		for (t in types) {
			list:List<Entity> = scene types get(t)
			if (list && (e = collideList(list))) break
		}
		
		(this x, this y) = (oldX, oldY)
		return e
	}
	
	collide: func ~typesNoPos (types:ArrayList<String>) -> Entity {
		if (mask == null) return null
		
		e:Entity
		for (t in types) {
			list:List<Entity> = scene types get(t)
			if (list && (e = collideList(list))) return e
		}
		null
	}
	
	collideList: func (list:List<Entity>) -> Entity {
		for (e in list) {
		 	if (e != this && e mask != null \
		 	&& (mask check(e mask) || e mask check(mask)) ) {
		 		return e
		 	}
		}
		null
	}
	
	position: inline func (.x, .y) {
		this x = x
		this y = y
	}
	
	removed: func // called when removed from world
	added: func   // called when added to world
}