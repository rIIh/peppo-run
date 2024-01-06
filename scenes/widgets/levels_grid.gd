@tool
class_name LevelsGrid extends Control

## [index] is a global grid index from [start_index] to `[start_index] + [grid_count]`
signal node_created(index: int, node: LevelButton)

@export
var start_index := 0 :
	set(value):
		if (start_index != value):
			start_index = value
			update()

@export
var grid_count := 6 :
	get: return grid_count
	set(value): pass

var _level_prefab := preload("res://prefabs/ui/level_button.tscn")


func _ready():
	await get_tree().process_frame
	if not is_inside_tree(): return
	
	update()

## Recreate level buttons
func update():
	for child in %grid.get_children():
		child.queue_free()

	for index in grid_count:
		var node = _level_prefab.instantiate() as LevelButton
		if Engine.is_editor_hint() or not node_created.get_connections():
			node.update(start_index + index, true)
		else:
			node_created.emit(start_index + index, node)

		%grid.add_child(node)
