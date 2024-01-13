extends Node

const _file_name = 'user://saves/savegame.json'

class LevelKey:
	var group: String
	var index: int
	
	func _init(group: String, index: int):
		self.group = group
		self.index = index
		
	func _to_json() -> Dictionary:
		return {'group': group, 'index': index}
		
	static func _from_json(json: Dictionary) -> LevelKey:
		return LevelKey.new(json['group'], json['index'])

signal level_unlocked(level: LevelKey)

var _unlocked_levels: Array[LevelKey] = []
var unlocked_levels: Array[LevelKey] :
	get: return _unlocked_levels.duplicate()
	
	
func _enter_tree():
	_load()
	

func set_level_unlocked(level: LevelKey):
	_unlocked_levels.append(level)
	level_unlocked.emit(level)
	_save()
	

func _save():
	var data = {
		'unlocked_levels': _unlocked_levels.map(func(it: LevelKey): return it._to_json())
	}
	
	DirAccess.make_dir_recursive_absolute('user://saves')
	
	var file = FileAccess.open(_file_name, FileAccess.WRITE)
	if file == null:
		print('failed to save - %s' % FileAccess.get_open_error())
		return
	
	var json = JSON.stringify(data)
	file.store_string(json)
	
	print(FileAccess.get_file_as_string(_file_name))

func _load():
	var data = {}
	if FileAccess.file_exists(_file_name):
		var json = FileAccess.get_file_as_string(_file_name)
		data = JSON.parse_string(json)
		
		if data == null:
			print('file is not valid')
			DirAccess.remove_absolute(_file_name)
			data = _get_defaults()
	else:
		print('file not exists')
		data = _get_defaults()
		
	for json in data['unlocked_levels']:
		_unlocked_levels.append(LevelKey._from_json(json))

func _get_defaults():
	return {
		"unlocked_levels": []
	}
