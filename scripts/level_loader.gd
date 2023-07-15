extends Node

@export
var custom_window_scale: float = 0

@export
var level_group: LevelGroup

var _index := 0
var index: int :
	get: return _index
	
@export
var level_spawn_parent: Node

@export
var restart_button: BaseButton

@export
var go_button: BaseButton

@export
var continue_button: BaseButton

var current_level: PackedScene :
	get: return level_group.get_level_scene(index)

var _instantiated_scene_node: GameMode


func _ready():
	restart()
	restart_button.pressed.connect(restart)
	continue_button.pressed.connect(go_to_next_level)
	
	print(DisplayServer.screen_get_dpi(), ', ', DisplayServer.screen_get_scale(), ', ', DisplayServer.screen_get_max_scale())
	get_tree().root.content_scale_factor = DisplayServer.screen_get_scale() if not custom_window_scale else custom_window_scale
	
	var size_delta = get_window().size * (get_tree().root.content_scale_factor - 1)
	get_window().size *= get_tree().root.content_scale_factor
	get_window().position = get_window().position - Vector2i(size_delta / 2)
	

func restart():
	assert(level_group, "No Level Group provided. Check parameters.")

	if _instantiated_scene_node:
		_instantiated_scene_node.queue_free()

	_instantiated_scene_node = current_level.instantiate()
	_instantiated_scene_node.state_changed.connect(_handle_state_change)
	_instantiated_scene_node.go_button = go_button

	if level_spawn_parent:
		level_spawn_parent.add_child(_instantiated_scene_node)
	else:
		add_child(_instantiated_scene_node)
	
	continue_button.visible = false


func go_to_next_level():
	assert(level_group.has_next_level(index))
	_index += 1

	restart()


func _handle_state_change(state: GameMode.State):
	if state == GameMode.State.success:
		continue_button.visible = level_group.has_next_level(index)
