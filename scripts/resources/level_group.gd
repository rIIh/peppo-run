extends Resource

class_name LevelGroup

@export
var _name: String = "default"
var name: String : 
	get: return _name

@export
var _levels: Array[LevelDetails] = []
var levels: Array[LevelDetails] :
	get: return Array(_levels)


func get_level_details(index: int) -> LevelDetails:
	return _levels[index]


func has_next_level(index: int) -> bool:
	return index + 1 < size()
	

func size() -> int:
	return _levels.size()
