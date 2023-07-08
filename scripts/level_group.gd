extends Resource

class_name LevelGroup

@export
var _name: String = "default"
var name: String : 
	get: return _name

@export
var _levels: Array[PackedScene] = []
var levels: Array[PackedScene] :
	get: return Array(_levels)


func get_level_scene(index: int) -> PackedScene:
	return _levels[index]


func has_next_level(index: int) -> bool:
	return index + 1 < size()
	

func size() -> int:
	return _levels.size()
