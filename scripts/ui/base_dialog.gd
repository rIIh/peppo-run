class_name BaseDialog extends Control


@onready var animation_player = %AnimationPlayer
@onready var dialog_root = %DialogRoot
@onready var backdrop = %Backdrop

signal opened
signal closed
signal backdrop_pressed

func _ready():
	var last_child = get_children().back() as Node
	if last_child != dialog_root:
		last_child.reparent(dialog_root)
		
	backdrop.pressed.connect(func(): backdrop_pressed.emit())
	

func open():
	if not is_node_ready(): await ready
	animation_player.play("open")
	
	var anim = await animation_player.animation_finished
	if anim == "open":
		opened.emit()


func close():
	if not is_node_ready(): await ready
	animation_player.play("close")
	
	var anim = await animation_player.animation_finished
	if anim == "close":
		closed.emit()

