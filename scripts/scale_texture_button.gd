@tool
class_name ScaleTextureButton extends TextureButton

@export
var texture_scale := Vector2.ONE


# TODO: use current texture of button
func _ready():
	if not self.texture_normal:
		return

	self.ignore_texture_size = true
	self.custom_minimum_size = self.texture_normal.get_size() * texture_scale
	self.stretch_mode = TextureButton.STRETCH_SCALE

func _process(delta):
	if not self.texture_normal:
		return

	self.ignore_texture_size = true
	self.custom_minimum_size = self.texture_normal.get_size() * texture_scale
	self.stretch_mode = TextureButton.STRETCH_SCALE
