class_name BaseDialog extends Control


@onready var animation_player = %AnimationPlayer
@onready var dialog_root = %DialogRoot

func open():
	if not is_node_ready(): await ready
	animation_player.play("open")
	
	
func close():
	if not is_node_ready(): await ready
	animation_player.play("close")

#@export
#var builder: Callable
#
#func _ready():
	#var node = builder
