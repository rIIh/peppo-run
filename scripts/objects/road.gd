@tool
extends Node2D


@export
var offset := 100:
	set(value):
		if (offset == value):
			return

		offset = value
		_update_cars()

@export
var cars: Array[PackedScene] = []:
	set(value):
		if (cars == value):
			return

		cars = value
		_update_cars()


@export
var spacing: float = 300:
	set(value):
		if (spacing == value):
			return

		spacing = value
		_update_cars()


@export
var length: float = 242:
	set(value):
		if (length == value):
			return

		length = value
		_update_nodes()


@export
var fade_value: float = 160:
	set(value):
		if (fade_value == value):
			return

		fade_value = value
		_update_nodes()


func _ready():
	_update_nodes()


func _update_nodes():
	if is_inside_tree():
		$road.size.y = length * 4
		$road.position = Vector2(length / 2, $road.position.y)

		print(get_children(true).map(func(i): return i.name))
		_update_materials(get_children())



func _update_materials(children: Array[Node]):
	for child in children:
		if child is CanvasItem:
			var material = child.material
			if material is ShaderMaterial:
				material.set_shader_parameter("fade_threshold", Vector2(length / 2, 1000))
				material.set_shader_parameter("fade_strength", fade_value)

		_update_materials(child.get_children())


func _update_cars():
	if not Engine.is_editor_hint():
		await ready

	for child in %cars.get_children():
		child.queue_free()

	var total_space = length + offset * 2
	var available_space = total_space
	while available_space > 0:
		var car: Car = cars.pick_random().instantiate()
		car.position.x = -length / 2 - offset + (total_space - available_space)
		if not Engine.is_editor_hint():
			car.position_changed.connect(func(position): _handle_car_position_changed(car, position))

		%cars.add_child(car)

		available_space -= spacing
		
	_update_materials(get_children())


func _handle_car_position_changed(car: Car, position: Vector2):
	if position.x > length / 2 + offset:
		car.position.x -= length + offset * 2


func _get_tool_buttons():
	return [
		{
			call=_update_cars,
			text="Replace Cars",
		}
	]
