import structs/[ArrayList, LinkedList, HashMap]
import vamos/[Engine, Signal, Entity]
import vamos/display/Color

// TODO: replace the current ArrayList system with linked lists

/**
 * Contains and updates entites
 */
Scene: class {
	
	created := false
	
	entities := ArrayList<Entity> new()
	types := HashMap<String, ArrayList<Entity>> new()
	classes := HashMap<Class, ArrayList<Entity>> new()
	added := ArrayList<Entity> new()
	removed := ArrayList<Entity> new()
	
	onEntityAdded := Signal<Entity> new()
	onEntityRemoved := Signal<Entity> new()
	onEnter := Signal<Scene> new()
	onLeave := Signal<Scene> new()
	
	color:Color
	
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
		
		for (e in removed) {
			e removed()
			onEntityRemoved dispatch(e)
			e scene = null
			entities remove(e)
			_removeType(e)
		}
		removed clear()
		
		for (e in added) {
			entities add(e)
			_addType(e)
			e scene = this
			e added()
			onEntityAdded dispatch(e)
		}
		added clear()
	}
	
	add: inline func (e:Entity) {
		added add(e)
	}
	
	remove: inline func (e:Entity) {
		removed add(e)
	}
	
	removeAll: inline func {
		for (e in entities)
			remove(e)
	}
	
	getFirst: func ~ofType(type:String) -> Entity {
		list:ArrayList<Entity> = types[type]
		if (!list) return null
		return list first()
	}
	
	getFirst: func ~ofClass <T> (T:Class) -> T {
		list:ArrayList<Entity> = classes[T]
		if (!list) return null
		return list first() as T
	}
	
	_addType: func (e:Entity) {
		if (e type == "") return
		list:ArrayList<Entity> = types[e type]
		if (!list) {
			list = ArrayList<Entity> new()
			types[e type] = list
		}
		list add(e)
	}
	
	_removeType: func (e:Entity) {
		list:ArrayList<Entity> = types[e type]
		if (!list) return
		list remove(e)
	}
	
}
