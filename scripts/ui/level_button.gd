@tool
class_name LevelButton extends Control

signal pressed

@export
var _level_name: String :
	set(value):
		if _level_name != value:
			_level_name = value
			_update_text()
			
var _level_index: int = 0
var _available: bool = true

@export
var rotation_factor := 2400

var opened_texture := preload("res://assets/ui/levels/level__opened@4x.png")
var closed_texture := preload("res://assets/ui/levels/level__closed@4x.png")

@onready
var _prev_position = global_position
var _velocity = Vector2.ZERO
var velocity: Vector2 :
	get: return _velocity

func update(level: int, is_available: bool):
	_level_index = level
	_available = is_available
	_update_text()

func set_custom_level_name(level_name: String):
	_level_name = level_name
	_update_text()

func _ready():
	_update_text()
	%sprite.texture = opened_texture if _available else closed_texture
	%button.pressed.connect(func(): pressed.emit())
	
var _rot_tween: Tween
func _physics_process(delta):
	if Engine.is_editor_hint(): return
	
	_velocity = (global_position - _prev_position) / delta
	_prev_position = global_position
	var target_rotation = clampf(velocity.x / rotation_factor, deg_to_rad(-15), deg_to_rad(15));
	
	if _rot_tween: _rot_tween.kill()
	_rot_tween = create_tween()
	_rot_tween.tween_property($Control, 'rotation', target_rotation, .1)
	#$Control.rotation = clampf(velocity.x / rotation_factor, deg_to_rad(-15), deg_to_rad(15))
	

func _update_text():
	%text.text = _level_name if _level_name else str(_level_index + 1)
