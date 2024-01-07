class_name Door extends Node2D

var _is_opened := false
var is_opened: bool :
	get: return _is_opened
	
@onready var animation_player = %AnimationPlayer

func open():
	if _is_opened: return
	_is_opened = true
	
	animation_player.play("open")

func close():
	if not _is_opened: return
	_is_opened = false
	
	animation_player.play_backwards("open")
