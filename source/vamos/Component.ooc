import vamos/[Entity, State]

// Used for shared behaviour in entities

Component: abstract class {
	
	name: String
	entity: Entity
	state: State { get {entity state} }
	active := true
	
	init: func (=name)
	
	reset: func
	added: func
	removed: func
	
	update: func (dt:Double)
	
}