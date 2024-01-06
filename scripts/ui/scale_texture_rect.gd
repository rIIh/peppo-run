extends TextureRect


@export
var texture_scale: Vector2 = Vector2.ONE :
	set(value): 
		texture_scale = value
		custom_minimum_size = _get_minimum_size()


func _get_minimum_size():
	var minimum_size = super.get_minimum_size()
	if minimum_size.is_zero_approx():
		return texture.get_size() * texture_scale
	
	return minimum_size * texture_scale
