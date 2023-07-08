extends Resource

class_name ColorLibrary

@export
var _colors: Dictionary = {}

func get_color(key: String) -> Color:
	return _colors.get(key)
