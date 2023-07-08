extends Node

@export
var level_group: LevelGroup

var _index := 0
var index: int :
	get: return _index

@export
var restart_button: Button

@export
var continue_button: Button

var current_level: PackedScene :
	get: return level_group.get_level_scene(index)

var _instantiated_scene_node: GameMode


func _ready():
	restart()
	restart_button.pressed.connect(restart)
	continue_button.pressed.connect(go_to_next_level)


func restart():
	assert(level_group, "No Level Group provided. Check parameters.")

	if _instantiated_scene_node:
		_instantiated_scene_node.queue_free()

	_instantiated_scene_node = current_level.instantiate()
	_instantiated_scene_node.state_changed.connect(_handle_state_change)
	
	add_child(_instantiated_scene_node)
	continue_button.visible = false

func go_to_next_level():
	assert(level_group.has_next_level(index))
	_index += 1

	restart()


func _handle_state_change(state: GameMode.State):
	if state == GameMode.State.success:
		continue_button.visible = level_group.has_next_level(index)
