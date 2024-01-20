class_name LevelEndPopup extends Control

enum Action {
	home,
	go,
	retry,
}


@export
var text: String = "Yeah!" :
	set(value):
		if text != value:
			%main_text.text = value

		text = value

@export
var actions: Array[Action] = [Action.home, Action.go, Action.retry]

@onready
var _home_button := %buttons__home

@onready
var _go_button := %buttons__go

@onready
var _retry_button := %buttons__retry


signal home_pressed
signal go_pressed
signal retry_pressed

signal exit_completed
signal enter_completed

func _ready():
	show_popup()
	
	if Action.home not in actions:
		_home_button.visible = false
	elif Action.go not in actions:
		_go_button.visible = false
	elif Action.retry not in actions:
		_retry_button.visible = false

	_home_button.pressed.connect(func(): home_pressed.emit())
	_go_button.pressed.connect(func(): go_pressed.emit())
	_retry_button.pressed.connect(func(): retry_pressed.emit())


func show_popup():
	$AnimationPlayer.play("level_end_popup_animation")
	if not ($AnimationPlayer.animation_finished as Signal).is_connected(_handle_animation_finished):
		$AnimationPlayer.animation_finished.connect(_handle_animation_finished)


func hide_popup():
	$AnimationPlayer.play_backwards()
	
	
func go_home():
	hide_popup()
	var router = NodeUtilities.get_parent_of_type(self, Router) as Router
	router.pop(exit_completed)


func _handle_animation_finished(animation: StringName):
	if animation == "level_end_popup_animation":
		if $AnimationPlayer.current_animation_position == 1:
			enter_completed.emit()
		else:
			exit_completed.emit()
