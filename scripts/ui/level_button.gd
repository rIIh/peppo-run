@tool
class_name LevelButton extends MarginContainer

@export
var level_name: String :
	set(value):
		if level_name != value:
			level_name = value
			
var level_index: int = 0
var available: bool = true

var opened_texture := preload("res://assets/ui/levels/level__opened@4x.png")
var closed_texture := preload("res://assets/ui/levels/level__closed@4x.png")


signal pressed


func _ready():
	_update_text()
	%sprite.texture = opened_texture if available else closed_texture
	%button.pressed.connect(func(): pressed.emit())

func _update_text():
	%text.text = level_name if level_name else str(level_index + 1)
