extends Node2D

class_name DrawPath

@export
var line_renderer: Line2D

@export
var start_drawing_trigger: CollisionObject2D

@onready
var poop: Poop = get_parent().get_parent()

var _target_toilet: Toilet
var target_toilet: Toilet :
	get: return _target_toilet

var _drawing: bool = false
var _points : Array[Vector2] = []
var _offset: Vector2

signal trajectory_created(points: Array[Vector2])

func get_points() -> Array[Vector2]:
	if _drawing:
		return []

	return _points


func check_has_trajectory() -> bool:
	return not _drawing and _points.size() > 0


func _ready():
	_clear_points()

	if start_drawing_trigger:
		start_drawing_trigger.input_event.connect(_try_start_drawing)


func _exit_tree():
	if start_drawing_trigger:
		start_drawing_trigger.input_event.disconnect(_try_start_drawing)


func _add_point(point: Vector2):
	_points.append(point);
	if line_renderer:
		line_renderer.add_point(point)


func _clear_points():
	_target_toilet = null
	_points.clear()

	if line_renderer:
		line_renderer.clear_points()


var _play_area: PlayArea
func _try_start_drawing(viewport: Node, event: InputEvent, shape_idx: int):
	if poop.game_mode.state != GameMode.State.drawing: return

	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		poop.game_mode.reset_poop_assignment(poop)

		_drawing = true;
		_clear_points()

#		_add_point(poop.position)

		if _play_area:
			_play_area.mouse_exited_play_area.disconnect(_handle_mouse_exited_play_area)

		_play_area = poop.game_mode.play_area
		if _play_area:
			_play_area.mouse_exited_play_area.connect(_handle_mouse_exited_play_area)


func _handle_mouse_exited_play_area():
	if _drawing:
		_drawing = false
		_clear_points()

		if _play_area:
			_play_area.blink()
			_play_area.mouse_exited_play_area.disconnect(_handle_mouse_exited_play_area)
			_play_area = null


func _try_end_drawing(event: InputEvent):
	if not _drawing: return

	if event is InputEventMouseButton and event.button_index == 1 and not event.is_pressed():
		_drawing = false

		if _play_area:
			_play_area.mouse_exited_play_area.disconnect(_handle_mouse_exited_play_area)
			_play_area = null

		var toilets = poop.game_mode.toilets.filter(func(t): return t.check_is_hovered())
		if toilets.size() != 1:
			_clear_points()
			return

		var toilet_target = toilets[0]
		if not poop.game_mode.assign_poop_to_toilet(poop, toilet_target):
			_clear_points()
		else:
			_target_toilet = toilet_target
			_offset = _points[0] - global_position


func _input(event):
	if not _drawing: return

	if (event is InputEventMouseButton and event.button_index == 1 and not event.is_pressed()):
		_try_end_drawing(event)

	if (event is InputEventMouseMotion and _drawing):
		_add_point(get_global_mouse_position())
