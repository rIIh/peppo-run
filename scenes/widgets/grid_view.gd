@tool
class_name GridView extends Control

## [index] is a local grid index from `0` to `grid_count`
signal node_created(index: int, node: LevelButton)
signal page_changed(prev_page: int, next_page: int)
signal grid_updated

@export
var count := 0 :
	set(value):
		if count != value:
			count = value
			update()

@export
var prefab: PackedScene

@onready
var scrollable := %scrollable as ScrollContainer

var page:
	get:
		if count == 0:
			return 0
		
		var node_size = scrollable.get_child(0).get_child(0).size.x
		node_size = node_size if node_size else size.x
		
		return round(scrollable.scroll_horizontal / node_size)
	set(value):
		goto_page(value)

func _ready():
	await get_tree().process_frame
	if not is_inside_tree(): return
	update()
	
	if not Engine.is_editor_hint():
		resized.connect(_handle_resize_changed)

var _is_dragging := false
func _input(event):
	if event is InputEventScreenDrag:
		print('bla')
		if event.speed.y < -10:
			self.get_tree().set_input_as_handled()
		elif event.speed.y > 10:
			self.get_tree().set_input_as_handled()
	elif event is InputEventScreenTouch:
		print('bla')
		if event.pressed:
			self.get_tree().set_input_as_handled()

	#if event is InputEventMouseButton:
		#_is_dragging = event.is_pressed()
		#get_viewport().set_input_as_handled()
		#
	if event is InputEventMouseMotion :
		if not _is_dragging: return
		
		if abs(event.velocity.x) > 5:
			_is_dragging = false
	
			if event.velocity.x > 2:
				goto_page(page + 1)
				get_viewport().set_input_as_handled()
			elif event.velocity.x < -2:
				goto_page(page - 1)
				get_viewport().set_input_as_handled()


var _scroll_tween: Tween
func goto_page(next_page: int):
	var prev_page = floori(scrollable.scroll_horizontal / size.x)
	var factor = abs(prev_page - next_page)
	
	if _scroll_tween: _scroll_tween.kill()
	_scroll_tween = create_tween()
	_scroll_tween.set_ease(Tween.EASE_IN_OUT)
	_scroll_tween.set_trans(Tween.TRANS_QUINT)
	_scroll_tween.tween_property(scrollable, 'scroll_horizontal', next_page * size.x, 0.5 * factor)
	
	page_changed.emit(prev_page, next_page)


func update():
	for child in %pages.get_children():
		child.queue_free()
	
	if not prefab: return
	
	for index in count:
		var node = prefab.instantiate()
		node_created.emit(index, node)
		
		var control = Control.new()
		control.custom_minimum_size = Vector2(size.x, size.y)
		control.add_child(node)
		
		%pages.add_child(control)
		
	await get_tree().process_frame
	grid_updated.emit()
		
func _handle_resize_changed():
	for child in %pages.get_children():
		child.custom_minimum_size = Vector2(size.x, size.y)

	scrollable.scroll_horizontal = page * size.x
