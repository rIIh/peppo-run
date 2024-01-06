class_name LevelSelector extends Control

const page_size = 6

@export
var level_group: LevelGroup = preload("res://resources/level_groups/main.tres")

@export
var previous_page_button: BaseButton

@export
var next_page_button: BaseButton

var level_button := preload("res://prefabs/ui/level_button.tscn")

@onready
var _grid := %grid as GridView

func _ready():
	_grid.node_created.connect(_handle_grid_page_created)
	_grid.page_changed.connect(_handle_page_changed)
	_update_page_view()

	await _grid.grid_updated
	if previous_page_button:
		previous_page_button.pressed.connect(previous_page)
		previous_page_button.visible = false

	if next_page_button:
		next_page_button.pressed.connect(next_page)
		next_page_button.visible = _grid.page < _grid.count


func previous_page():
	if _grid.page == 0:
		return

	_grid.page -= 1
	_update_page_view()

func next_page():
	if _grid.page == _grid.count:
		return

	_grid.page += 1
	_update_page_view()

func _handle_page_changed(prev_page: int, next_page: int):
	if previous_page_button:
		previous_page_button.visible = next_page > 0

	if next_page_button:
		next_page_button.visible = next_page < (_grid.count - 1)

func _update_page_view():
	_grid.count = ceili(level_group.size() / page_size) + 1
	_grid.update()

func _handle_grid_page_created(index: int, node: LevelsGrid):
	node.node_created.connect(_handle_level_node_created)
	node.start_index = index * node.grid_count
	node.update()

func _handle_level_node_created(index: int, node: LevelButton):
	if index >= level_group.size():
		node.queue_free()
		return
	
	var details = level_group.get_level_details(index)
	var name = level_group.get_level_details(index).title if details else "WIP"

	if details:
		node.pressed.connect(func(): _handle_pressed(index))
	node.update(index, true)
	node.set_custom_level_name(name)

func _handle_pressed(index: int):
	var router: Router = NodeUtilities.get_parent_of_type(self, Router)
	router.push(
		preload("res://scenes/pages/game_page.tscn"),
		func(game_scene: GameScene):
			game_scene.initial_index = index
	)
