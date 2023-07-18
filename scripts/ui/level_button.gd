class_name LevelButton extends MarginContainer


var level_name: String
var level_index: int = 0
var available: bool = true

var opened_texture := preload("res://assets/ui/levels/level__opened@4x.png")
var closed_texture := preload("res://assets/ui/levels/level__closed@4x.png")


signal pressed


func _ready():
	%text.text = level_name if level_name else str(level_index + 1)
	%sprite.texture = opened_texture if available else closed_texture
	%button.pressed.connect(func(): pressed.emit())

