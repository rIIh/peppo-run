class_name LevelSelector extends Control

const page_size = 6

@export
var level_group: LevelGroup = preload("res://resources/level_groups/main.tres")

@export
var previous_page_button: BaseButton

@export
var next_page_button: BaseButton

var level_button := preload("res://prefabs/ui/level_button.tscn")

var page: int = 0

func _ready():
	_update_page_view()

	if previous_page_button:
		previous_page_button.pressed.connect(previous_page)
		previous_page_button.visible = false

	if next_page_button:
		next_page_button.pressed.connect(next_page)
		next_page_button.visible = page < level_group.levels.size() / page_size


func previous_page():
	if page == 0:
		return

	page -= 1
	_update_page_view()

	if page == 0:
		previous_page_button.visible = false

	if page < level_group.levels.size() / page_size:
		next_page_button.visible = true


func next_page():
	if page == level_group.levels.size() / page_size:
		return

	page += 1
	_update_page_view()

	if page == level_group.levels.size() / page_size:
		next_page_button.visible = false

	if page > 0:
		previous_page_button.visible = true


func _update_page_view():
	for child in %h_flow.get_children():
		child.queue_free()

	var pages = level_group.levels.size() / page_size
	for index in range(page * page_size, (page + 1) * page_size):
		if index >= level_group.levels.size():
			break

		var name = level_group.get_level_details(index).title

		var node: LevelButton = level_button.instantiate()
		node.pressed.connect(func(): _handle_pressed(index))
		node.level_name = name
		node.level_index = index
		node.available = true

		%h_flow.add_child(node)


func _handle_pressed(index: int):
	var router: Router = NodeUtilities.get_parent_of_type(self, Router)
	router.push(
		preload("res://scenes/game_scene.tscn"),
		func(game_scene: GameScene):
			game_scene.initial_index = index
	)
