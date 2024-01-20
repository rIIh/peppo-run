@tool
extends ScaleTextureButton

@onready var shadow = %shadow


@export
var main_texture: Texture2D :
	get: return texture_normal
	set(value):
		texture_normal = value

		if not is_node_ready():
			await ready

		shadow.size = texture_normal.get_size() * texture_scale
		shadow.custom_minimum_size = texture_normal.get_size() * texture_scale
		
		await get_tree().process_frame
		shadow.position = Vector2(0, 4)


# TODO: use current texture of button
func _ready():
	if not Engine.is_editor_hint():
		button_up.connect(func(): _handle_toggled(false))
		button_down.connect(func(): _handle_toggled(true))
		
	shadow.size = texture_normal.get_size() * texture_scale
	shadow.custom_minimum_size = texture_normal.get_size() * texture_scale
	await get_tree().process_frame
	shadow.position = Vector2(0, 4)

	super._ready()


var _is_pressed = false
var _tween: Tween
var _waiting: bool = false
func _handle_toggled(is_pressed: bool) -> void:
	if _is_pressed != is_pressed and not _waiting:
		if _tween and _tween.is_running():
			_tween.kill()

		_tween = create_tween()
		if is_pressed:
			_tween.tween_property(shadow, "position", Vector2(0, 1), .075)
		else:
			_tween.tween_property(shadow, "position", Vector2(0, 4), .075)

	_is_pressed = is_pressed

