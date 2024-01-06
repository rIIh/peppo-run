extends HBoxContainer

@export
var inactive_color: Color = Color.WHITE

@export
var active_color: Color = Color.from_string("#5992FF", Color.DODGER_BLUE)

@export
var grid_view: GridView : 
	set(value):
		var prev_grid_view = grid_view
		grid_view = value
		_reconnect(prev_grid_view)

var _active_index: int

func _ready():
	_reconnect(grid_view)


func _reconnect(prev_grid_view: GridView):
	if prev_grid_view:
		if prev_grid_view.page_changed.is_connected(_handle_page_changed):
			prev_grid_view.page_changed.disconnect(_handle_page_changed)
		if prev_grid_view.grid_updated.is_connected(_handle_grid_view_updated):
			prev_grid_view.grid_updated.disconnect(_handle_grid_view_updated)
		
	if grid_view:
		grid_view.page_changed.connect(_handle_page_changed)
		grid_view.grid_updated.connect(_handle_grid_view_updated)

var _tweens: Dictionary = {}
func _handle_page_changed(prev_page: int, next_page: int):
	_animate(_active_index, false)
	_animate(next_page, true)
	_active_index = next_page

	print('indicator: %s -> %s' % [_active_index, next_page])
	
func _animate(index: int, state: bool):
	var node = get_child(index) as Panel
	var stylebox = node.get_theme_stylebox('panel') as StyleBoxFlat
	
	if _tweens.has(index): _tweens.get(index).kill()
	var tween = create_tween()
	_tweens[index] = tween
	
	tween.set_parallel()
	tween.tween_property(stylebox, 'bg_color', active_color if state else inactive_color, 0.25)
	tween.tween_property(node, 'custom_minimum_size', Vector2(18, node.custom_minimum_size.y) if state else Vector2(8, node.custom_minimum_size.y), 0.25)

func _handle_grid_view_updated():
	for child in get_children():
		child.queue_free()
		
	for index in grid_view.count:
		var node = Panel.new()
		var stylebox = StyleBoxFlat.new()
		var is_active = index == grid_view.page
		stylebox.bg_color = active_color if is_active else inactive_color
		stylebox.set_corner_radius_all(4)
		
		node.custom_minimum_size = Vector2(18, 8) if is_active else Vector2(8, 8)
		node.add_theme_stylebox_override('panel', stylebox)
		
		add_child(node)
	
	_active_index = grid_view.page
