@tool
extends Resource

class_name LevelGroup

@export_dir
var _scenes_path: String


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


func _fill_from_scenes_path():
	if not _scenes_path:
		print("No path specified")
		return
		
	var levels: Array[LevelDetails] = []
		
	var files := DirAccess.get_files_at(_scenes_path)
	for file in files:
		if not file.ends_with('.tscn'): continue
		
		var details = LevelDetails.new()
		details.scene = ResourceLoader.load(_scenes_path + '/' + file)
		levels.append(details)
		
	_levels = levels
	emit_changed()

	
static func _get_tool_buttons():
	return [
		"_fill_from_scenes_path",
	]
