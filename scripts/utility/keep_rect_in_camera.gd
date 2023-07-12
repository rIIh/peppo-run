@tool
extends Control

# TODO: add border gizmo
class_name PlayArea

@onready
var _initial_color: Color = $border.self_modulate

var camera: Camera2D

signal mouse_exited_play_area

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.is_editor_hint():
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		$play_area__trigger.mouse_exited.connect(func(): mouse_exited_play_area.emit())
		
		$play_area__trigger/play_area__collider.shape = $play_area__trigger/play_area__collider.shape.duplicate()
		$play_area__trigger/play_area__collider.shape.size = self.size
		$play_area__trigger/play_area__collider.position = self.size / 2


var _tween: Tween
func blink():
	if _tween:
		_tween.kill()
		
	_tween = create_tween()
	_tween.tween_property($border, "self_modulate", Color(1,1,1,_initial_color.a * 2), .240).set_trans(Tween.TRANS_EXPO)
	_tween.tween_property($border, "self_modulate", _initial_color, .240).set_trans(Tween.TRANS_EXPO)
	_tween.play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not Engine.is_editor_hint():
		var camera = get_viewport().get_camera_2d()
		if not camera:
			return
		
		camera.position = get_rect().get_center()
		var scale_x = get_viewport_rect().size.x / get_rect().size.x
		var scale_y = get_viewport_rect().size.y / get_rect().size.y
		
		var min_scale = min(scale_x, scale_y)
		camera.zoom = Vector2(min_scale, min_scale)
		
		$border.visible = get_viewport_rect().size.aspect() > (get_rect().size + Vector2(32, 0)).aspect()

	if Engine.is_editor_hint() and $play_area__trigger/play_area__collider.shape.size != self.size:
		$play_area__trigger/play_area__collider.shape = $play_area__trigger/play_area__collider.shape.duplicate()
		$play_area__trigger/play_area__collider.shape.size = self.size
		$play_area__trigger/play_area__collider.position = self.size / 2
