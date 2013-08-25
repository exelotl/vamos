import structs/[ArrayList, List, HashMap]
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
		set (m) {
			if (m) m entity = this
			mask = m
		}
		get { mask }
	}
	
	// render priority of the entity
	// lower layers are rendered first, so they appear behind other objects
	layer: Int {
		get
		set (l) {
			if (scene)  {
				scene _removeFromLayer(this)
				layer = l
				scene _addToLayer(this)
			} else {
				layer = l
			}
		}
	}
	layer = 0
	
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
				return comp
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
	
	removed: func // called when removed from scene
	added: func   // called when added to scene
	
	on: func (name:String, f:Func(Signal)) -> Listener {
		l := Listener new(f, this)
		return scene on(name, l)
	}
	
	on: func ~noArg (name:String, f:Func) -> Listener {
		on(name, |s| f())
	}
	
	off: func (name:String, l:Listener) {
		scene off(name, l)
	}
	off: func ~allOfName (name:String) {
		arr := scene listeners get(name) as ArrayList<Listener>
		if (!arr) return
		for (l in arr) {
			if (l entity == this)
				scene off(name, l)
		}
	}
	off: func ~all {
		scene listeners keys each(|k,v| off(k as String))
	}
	
	broadcast: func (sig:Signal) {
		scene broadcast(sig)
	}
	
	broadcast: func ~shorthand <T> (name:String, data:T) {
		cell:Cell<T> = Cell<T> new(data)
		broadcast(Signal new(this, name, cell))
	}
	
	broadcast: func ~shorthandEmpty (name:String) {
		broadcast(Signal new(this, name, null))
	}

}
