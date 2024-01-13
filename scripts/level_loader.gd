class_name GameScene extends Node


var initial_index: int

@export
var level_group: LevelGroup

@onready
var _index := initial_index
var index: int :
	get: return _index

@export
var level_spawn_parent: Node

@export
var ui_parent: Node

@export
var restart_button: BaseButton

@export
var go_button: BaseButton

var _success_popup := preload("res://prefabs/ui/level_end_popup.tscn")

var current_level: LevelDetails :
	get: return level_group.get_level_details(index)

var _instantiated_scene_node: GameMode

signal restarted
signal failed_popup_waited(should_show_popup: bool)


func _ready():
	restart()
	restart_button.pressed.connect(restart)


func restart():
	failed_popup_waited.emit(false)
	assert(level_group, "No Level Group provided. Check parameters.")

	if _instantiated_scene_node:
		_instantiated_scene_node.queue_free()

	_instantiated_scene_node = current_level.scene.instantiate()
	_instantiated_scene_node.state_changed.connect(_handle_state_change)
	_instantiated_scene_node.go_button = go_button

	if level_spawn_parent:
		level_spawn_parent.add_child(_instantiated_scene_node)
	else:
		add_child(_instantiated_scene_node)
		
	restarted.emit()
	%level_header__level_number.text = current_level.title


func go_to_next_level():
	if not level_group.has_next_level(index):
		var router := NodeUtilities.get_parent_of_type(self, Router) as Router
		router.pop()
		return

	_index += 1

	restart()


func _do_from_popup(popup: LevelEndPopup, action: Callable):
	popup.hide_popup()
	await popup.exit_completed
	popup.queue_free()
	
	action.call()

func _handle_state_change(state: GameMode.State):
	if state == GameMode.State.success:
		var popup: LevelEndPopup = _success_popup.instantiate()
		ui_parent.add_child(popup)
		popup.text = ["Yeah!", "Rock On!", "Got It!", "Well Done!", "Boo-ya!", "Huzzah!"].pick_random()
		popup.show_popup()

		popup.go_pressed.connect(_do_from_popup.bind(popup, go_to_next_level))
		popup.retry_pressed.connect(_do_from_popup.bind(popup, restart))
		
	elif state == GameMode.State.failed:
		get_tree().create_timer(2).timeout.connect(func(): failed_popup_waited.emit(true))
		restarted.connect(func(): failed_popup_waited.emit(false))
		
		var should_show_popup = await failed_popup_waited
		if not should_show_popup:
			return
		
		var popup: LevelEndPopup = _success_popup.instantiate()
		popup.text = ["Whoops!"].pick_random()
		popup.actions = [LevelEndPopup.Action.home, LevelEndPopup.Action.retry]
		
		ui_parent.add_child(popup)
		popup.show_popup()

		popup.go_pressed.connect(_do_from_popup.bind(popup, go_to_next_level))
		popup.retry_pressed.connect(_do_from_popup.bind(popup, restart))

