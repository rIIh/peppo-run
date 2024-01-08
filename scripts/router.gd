class_name Router extends Node


@export
var initial_scene: PackedScene

var _history: Array[Node] = []


signal popped
signal pushed

func _ready():
	if initial_scene:
		push(initial_scene)


func can_pop() -> bool:
	return _history.size() > 1


func pop() -> bool:
	if _history.size() == 1:
		return false
		
	return force_pop()


func force_pop() -> bool:
	_history.pop_back().queue_free()
	if _history.size() > 0:
		_history[-1].visible = true
		
	popped.emit()
	return true

func push(scene: PackedScene, setup: Callable = Callable()):
	if _history.size():
		_history[-1].visible = false
		
	var node = scene.instantiate()
	_history.append(node)
	
	if setup:
		setup.call(node)
	
	add_child(node)
	pushed.emit()
