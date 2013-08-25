import structs/[List, ArrayList, HashMap]
import vamos/[Engine, Entity, Graphic, Component]

/**
 * Contains and updates entites
 */
Scene: class {
	
	created := false
	
	entities := ArrayList<Entity> new()
	types := HashMap<String, ArrayList<Entity>> new()
	layers := HashMap<Int, ArrayList<Entity>> new()
	layerOrder := ArrayList<Int> new()
	addList := ArrayList<Entity> new()
	removeList := ArrayList<Entity> new()
	listeners := HashMap<String, ArrayList<Listener>> new()
	
	// for timers, tweens and stuff that apply to the whole scene
	compHolder := Entity new()
	compHolder scene = this
	
	/// Don't create entities or load assets here, the engine might not be ready.
	init: func
	
	/// Called when a renderer is available, and entities/graphics can be initialised
	create: func

	enter: func (prev:Scene)
	leave: func (next:Scene)
	
	update: func (dt:Double) {
		
		for (e in entities) {
			e updateComps(dt)
			e updateGraphic(dt)
			e update(dt)
		}
		
		for (e in removeList) {
			e removed()
			e off()
			e scene = null
			entities remove(e)
			_removeFromLayer(e)
			_removeFromType(e)
		}
		removeList clear()
		
		for (e in addList) {
			entities add(e)
			_addToLayer(e)
			_addToType(e)
			e scene = this
			e added()
		}
		addList clear()
		
		//compHolder updateComps(dt)
	}
	
	add: func (e:Entity) {
		addList add(e)
	}
	
	remove: func (e:Entity) {
		removeList add(e)
	}
	
	//addComp: func (c:Component) {
	//	compHolder add(c)
	//}
	//removeComp: func (c:Component) {
	//	compHolder remove(c)
	//}
	
	removeAll: func {
		for (e in entities)
			remove(e)
	}
	
	addGraphic: func (graphic:Graphic, x, y:Double) -> Entity {
		e := Entity new(x, y)
		e graphic = graphic
		add(e)
		return e
	}
	
	getFirst: func ~ofType(type:String) -> Entity {
		list:ArrayList<Entity> = types[type]
		if (!list || list size == 0) return null
		return list first()
	}
	
	getFirst: func ~ofClass <T> (T:Class) -> T {
		for (e in entities)
			if (e class == T)
				return e as T
		for (e in addList)
			if (e class == T)
				return e as T
		null
	}
	
	each: func (type:String, f:Func(Entity)->Bool) {
		for (e in types[type] as ArrayList<Entity>)
			if (!f(e)) return
	}
	
	
	on: func (name:String, l:Listener) -> Listener {
		arr:ArrayList<Listener> = listeners[name]
		if (!arr) {
			arr = ArrayList<Listener> new()
			listeners[name] = arr
		}
		arr remove(l)
		arr add(l)
		return l
	}
	
	on: func ~shorthand (name:String, f:Func(Signal)) -> Listener {
		on(name, Listener new(f, null))
	}
	
	on: func ~shorthandNoArg (name:String, f:Func) -> Listener {
		on(name, Listener new(|s| f(), null))
	}
	
	
	off: func (name:String, l:Listener) {
		arr:ArrayList<Listener> = listeners[name]
		if (arr) arr remove(l)
	}
	
	broadcast: func (sig:Signal) {
		arr:ArrayList<Listener> = listeners[sig name]
		if (!arr) return
		for (l in arr) {
			l call(sig)
		}
	}
	
	broadcast: func ~shorthand <T> (name:String, data:T) {
		cell := Cell<T> new(data)
		broadcast(Signal new(null, name, cell))
	}
	
	broadcast: func ~shorthandEmpty <T> (name:String) {
		broadcast(Signal new(null, name, null))
	}
	
	_addToType: func (e:Entity) {
		if (e type == "") return
		list:ArrayList<Entity> = types[e type]
		if (!list) {
			list = ArrayList<Entity> new()
			types[e type] = list
		}
		list add(e)
	}
	
	_removeFromType: func (e:Entity) {
		list:ArrayList<Entity> = types[e type]
		if (!list) return
		list remove(e)
	}
	
	
	_addToLayer: func (e:Entity) {
		list:ArrayList<Entity> = layers[e layer]
		if (!list) {
			list = ArrayList<Entity> new()
			layers[e layer] = list
			layerOrder add(e layer)
			layerOrder sort(|a,b| a>b)
		}
		list add(e)
	}
	
	_removeFromLayer: func (e:Entity) {
		list:ArrayList<Entity> = layers[e layer]
		if (!list) return
		list remove(e)
	}
	
}


Signal: class {

	sender: Entity
	name: String
	cell: Cell<Pointer>
	
	init: func (=sender, =name, =cell)

	/// Retrieve the data stored in the signal.
	get: func <T> (T:Class) -> T {
		if (!cell) return null
		cell[T]
	}
}

Listener: class {	
	
	entity: Entity
	f: Func(Signal)
	
	init: func (=f, =entity)
	
	call: func (s:Signal) {
		f(s)
	}
}
