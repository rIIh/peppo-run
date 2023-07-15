@tool
extends Control

# TODO: add border gizmo
class_name PlayArea

@onready
var _initial_color: Color = $dashed_border.color if $dashed_border else Color.TRANSPARENT

var game_viewport: GameViewport

signal mouse_exited_play_area

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.is_editor_hint():
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		$play_area__trigger.mouse_exited.connect(func(): mouse_exited_play_area.emit())

		$play_area__trigger/play_area__collider.shape = $play_area__trigger/play_area__collider.shape.duplicate()
		$play_area__trigger/play_area__collider.shape.size = self.size
		$play_area__trigger/play_area__collider.position = self.size / 2


func _enter_tree():
	game_viewport = NodeUtilities.get_parent_of_type(self, GameViewport)


var _tween: Tween
func blink():
	if _tween:
		_tween.kill()

	if not $dashed_border:
		return

	_tween = create_tween()
	_tween.tween_property($dashed_border, "color", Color(1,1,1,_initial_color.a * 2), .240).set_trans(Tween.TRANS_EXPO)
	_tween.tween_property($dashed_border, "color", _initial_color, .240).set_trans(Tween.TRANS_EXPO)
	_tween.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not Engine.is_editor_hint():
		var scale_factor = get_tree().root.content_scale_factor
		var camera: Camera2D = game_viewport.camera if game_viewport else get_viewport().get_camera_2d()
		if not camera:
			return

		var target_view_rect: Rect2 = game_viewport.target_rect.get_global_rect() if game_viewport and game_viewport.target_rect else null
		target_view_rect = target_view_rect if target_view_rect else get_viewport_rect()


		var scale_x = target_view_rect.size.x / get_rect().size.x
		var scale_y = target_view_rect.size.y / get_rect().size.y
#
		var min_scale = min(scale_x, scale_y)
		camera.position = -target_view_rect.position / min_scale \
			- (target_view_rect.size - get_rect().size * min_scale) / min_scale / 2 \
			+ (get_rect().position)
		camera.zoom = Vector2(min_scale, min_scale)


#		$dashed_border.visible = target_view_rect.size.aspect() > (get_rect().size + Vector2(32, 0)).aspect()

	if Engine.is_editor_hint() and $play_area__trigger/play_area__collider.shape.size != self.size:
		$play_area__trigger/play_area__collider.shape = $play_area__trigger/play_area__collider.shape.duplicate()
		$play_area__trigger/play_area__collider.shape.size = self.size
		$play_area__trigger/play_area__collider.position = self.size / 2
