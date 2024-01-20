extends Control

@export var enabled_color: Color = Color.from_string('#15eaba', Color.LIME_GREEN)
@export var disabled_color: Color = Color.from_string('#ff7089', Color.RED)

@onready var thumb_control = %"Thumb Control"
@onready var thumb_position = %"Thumb Position"
@onready var thumb = %Thumb

var _tween: Tween
@export var state: bool = false :
	set(value):
		if _tween: _tween.kill()
		
		state = value
		_tween = create_tween()
		var x_position = thumb_control.size.x - thumb.size.x if state else 0.0
		_tween.tween_property(thumb_position, "position", Vector2(x_position, thumb_position.position.y), .25)
	


func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("ui_accept"):
			state = !state
