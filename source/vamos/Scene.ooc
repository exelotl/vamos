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
	

	/**
	 * You can override this to intercept signals from entities, take global
	 * action on them, or prevent them from being broadcasted to other entities.
	 */
	handle: func <T> (sig:Signal<T>) -> Bool {
		true
	}
	
	/**
	 * Send a message to all entities in the scene (apart from the sender)
	 */
	broadcast: func <T> (sig:Signal<T>) {
		broadcast(entities, sig)
	}

	/**
	 * Send a message to all entities of a certain type
	 */
	broadcast: func ~type <T> (type:String, sig:Signal<T>) {
		list:ArrayList<Entity> = types[type]
		if (list) broadcast(list, sig)
	}

	/**
	 * Send a message to all entities in an array of types
	 */
	broadcast: func ~types <T> (arr:String[], sig:Signal<T>) {
		for (i in 0..arr length)
			broadcast(arr[i], sig)
	}

	/**
	 * Send a message to all entities in the given List
	 */
	broadcast: func ~list <T> (list:List<Entity>, sig:Signal<T>) {
		for (e in list)
			if (e != sig sender)
				e handle(sig)
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

/**
 * The unit of communication for the broadcast/handle system.
 */
Signal: class <T> {

	sender: Entity
	name: String
	data: T
	
	init: func (=sender, =name, =data)

	
	/// Retrieve the data stored in the signal.
	get: func <X> (X:Class) -> X {
		if (!T inheritsFrom?(X))
			raise("get(%s) called but signal data is of type %s!" format(X name, T name))
		return data
	}
}