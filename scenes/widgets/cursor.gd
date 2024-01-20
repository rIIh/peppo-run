extends Node2D

@onready var default_animation = %DefaultAnimation

static var _mouse_mode := Input.mouse_mode

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_global_mouse_position()


static var _active_cursors := 0
func _enter_tree():
	_active_cursors += 1
	_mouse_mode = Input.mouse_mode
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	print(get_parent())

func _exit_tree():
	_active_cursors -= 1
	if _active_cursors == 0:
		Input.set_mouse_mode(_mouse_mode)

func _input(event):
	if event is InputEventMouseButton and event.button_index == 1:
		default_animation.play("click")
		if event.is_released():
			default_animation.play_backwards()
		elif event.is_pressed():
			default_animation.play()
			
