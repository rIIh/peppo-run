class_name Router extends Node

static var _noop_signal = Signal()

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

# TODO: research influence on z-index
func remove(route: Node, after: Signal = _noop_signal):
	var index = _history.rfind(route)
	if index == -1: return
	
	var node: Node = _history.pop_at(index)
	if after != _noop_signal: await after
	node.queue_free()

# TODO: research influence on z-index
func pop(after: Signal = _noop_signal) -> bool:
	if _history.size() == 1:
		return false
		
	return await force_pop(after)
	
# TODO: research influence on z-index
func force_pop(after: Signal = _noop_signal) -> bool:
	var node = _history.pop_back()
	if after != _noop_signal: await after
	node.queue_free()
	
	if _history.size() > 0:
		_history[-1].visible = true
		
	popped.emit()
	return true

func push(scene: PackedScene, setup: Callable = Callable()):
	var node = scene.instantiate()
	var route_info = node.get_children().filter(func(n): return n is RouteInfo).front() as RouteInfo
	if node.has_method('set_z_index'):
		node.z_index = _history.size() * 100
	
	if _history.size() and (not route_info or not route_info.is_transparent):
		var prev_node = _history[-1]
		if prev_node.has_method('set_visible'):
			prev_node.visible = false
		
	_history.append(node)
	
	if setup:
		setup.call(node)
	
	add_child(node)
	pushed.emit()
