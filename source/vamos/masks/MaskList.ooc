import structs/ArrayList
import vamos/Mask

MaskList: class extends Mask {

	masks: ArrayList<Mask>

	init: func (=masks)
	init: func~rawArray (arr:Mask[]) {
		init(arr as ArrayList<Mask>)
	}
	init: func~empty {
		init(ArrayList<Mask> new())
	}
	
	check: func (other: Mask) -> Bool {
		for (mask in masks) {
			mask entity = entity
			if (mask active)
				if (mask check(other)) return true
		}
		return false
	}
	
	add: func (mask: Mask) {
		masks add(mask)
	}
	
	remove: func (mask: Mask) {
		masks remove(mask)
	}
	
	removeAt: func (index: Int) {
		if (index >= masks size) return
		masks removeAt(index)
	}
	
	removeAll: func () {
		masks clear()
	}
	
}