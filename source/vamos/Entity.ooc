import structs/[ArrayList, List]
import vamos/[State, Component, Graphic, Mask]

Entity: class {
	
	x, y:Double
	
	state: State
	graphic: Graphic
	components := ArrayList<Component> new()
	
	type: String {
		get
		set (t) {
			if (state)  {
				state _removeType(this)
				type = t
				state _addType(this)
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
	
	addComp: func (comp:Component) {
		components remove(comp)
		components add(comp)
		comp entity = this
		comp added()
	}
	
	addComp: func ~withName (name:String, comp:Component) {
		comp name = name
		addComp(comp)
	}
	
	removeComp: func (comp:Component) {
		comp removed()
		comp entity = null
	}
	
	removeComp: func ~byName (name:String) {
		removeComp(getComp(name))
	}
	
	getComp: func ~byName (name:String) -> Component {
		for (comp in components) {
			if (comp name == name)
				return comp
		}
		return null
	}
	
	getComp: func ~byClass (class:Class) -> Component {
		for (comp in components) {
			if (comp class == class)
				return comp
		}
		return null
	}
	
	collideCheck: func (list:List<Entity>) -> Entity {
		for (e in list) {
		 	if (e != this && e mask != null \
		 	&& (mask check(e mask) || e mask check(mask)) ) {
		 		return e
		 	}
		}
		null
	}
	
	collide: func (type:String, x, y:Double) -> Entity {
		if (mask == null) return null
		list:List<Entity> = state types get(type)
		if (list == null) return null
		
		(oldX, oldY) := (this x, this y)
		(this x, this y) = (x, y)
		
		e := collideCheck(list)
		
		(this x, this y) = (oldX, oldY)
		return e
	}
	
	collide: func ~noPos (type:String) -> Entity {
		if (mask == null) return null
		list:List<Entity> = state types get(type)
		if (list == null) return null
		return collideCheck(list)
	}
	
	collide: func ~types (types:ArrayList<String>, x, y:Double) -> Entity {
		if (mask == null) return null
		(oldX, oldY) := (this x, this y)
		(this x, this y) = (x, y)
		
		e:Entity
		for (t in types) {
			list:List<Entity> = state types get(t)
			if (list && (e = collideCheck(list))) break
		}
		
		(this x, this y) = (oldX, oldY)
		return e
	}
	
	collide: func ~typesNoPos (types:ArrayList<String>) -> Entity {
		if (mask == null) return null
		
		e:Entity
		for (t in types) {
			list:List<Entity> = state types get(t)
			if (list && (e = collideCheck(list))) return e
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