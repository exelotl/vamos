import vamos/[Entity, State]

// Used for shared behaviour in entities

Component: abstract class {
	
	name: String
	entity: Entity
	state: State { get {entity state} }
	active := true
	
	init: func (=name)
	init: func ~noName
	
	reset: func
	added: func
	removed: func
	
	update: func (dt:Double)
	
}