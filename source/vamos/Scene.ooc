import structs/[ArrayList, LinkedList, HashMap]
import vamos/[Engine, Signal, Entity, Graphic, Component]

// TODO: replace the current ArrayList system with linked lists

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
	
	onEntityAdded := Signal<Entity> new()
	onEntityRemoved := Signal<Entity> new()
	onEnter := Signal<Scene> new()
	onLeave := Signal<Scene> new()
	
	// for timers, tweens and stuff that apply to the whole scene
	compHolder := Entity new()
	compHolder scene = this
	
	// Don't create entities or load assets here.
	init: func {
		
	}
	
	/// Called when a renderer is available, and entities/graphics can be initialised
	create: func {
		
	}
	
	update: func (dt:Double) {
		
		for (e in entities) {
			e updateComps(dt)
			e updateGraphic(dt)
			e update(dt)
		}
		
		for (e in removeList) {
			e removed()
			onEntityRemoved dispatch(e)
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
			onEntityAdded dispatch(e)
		}
		addList clear()
		
		//compHolder updateComps(dt)
	}
	
	//on: func~trigger(event:String, data:Object) {
	//	
	//}
	//on: func~bind(event:String, )
	
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
