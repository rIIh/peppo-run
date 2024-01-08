@tool
class_name WeightButton extends Node2D


signal pressed
signal unpressed

@export var is_toggle := true
@export var sprites: WeightButtonsSprites:
	set(value):
		sprites = value
		
		if not is_node_ready(): await ready
		print(is_node_ready())
		print(value.pressed_sprite)
		pressed_sprite.texture = sprites.pressed_sprite
		unpressed_sprite.texture = sprites.unpressed_sprite


@onready var animation_tree = %AnimationTree
@onready var trigger = %trigger
@onready var pressed_sprite = %pressed_sprite
@onready var unpressed_sprite = %unpressed_sprite

var is_pressed := false :
	set(value):
		if Engine.is_editor_hint(): 
			is_pressed = value
		elif is_pressed != value:
			is_pressed = value
			
			animation_tree["parameters/conditions/is_not_pressed"] = not is_pressed
			animation_tree["parameters/conditions/is_pressed"] = is_pressed
			
			if is_pressed:
				pressed.emit()
			else:
				unpressed.emit()


func _ready():
	if Engine.is_editor_hint(): return
	trigger.body_entered.connect(func(node): is_pressed = true)
	trigger.body_exited.connect(func(node): if not is_toggle:  is_pressed = false)
	
	trigger.area_entered.connect(func(node): is_pressed = true)
	trigger.area_exited.connect(func(node): if not is_toggle: is_pressed = false)



