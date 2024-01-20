@tool
class_name EditorBackgroundOverride extends Node


@onready var color_rect = %ColorRect

@export var color: Color :
	set(value):
		color = value
		
		if not is_node_ready(): await ready
		color_rect.color = color


# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.is_editor_hint():
		queue_free()
		return

func _enter_tree():
	if not Engine.is_editor_hint():
		queue_free()
		return
	
	await ready
	color_rect.color = color
	
func _process(delta):
	var viewport := EditorInterface.get_editor_viewport_2d()
	var rect = viewport.get_visible_rect()
	var transform = viewport.get_final_transform()
	
	if rect != null and transform != null:
		color_rect.global_position = rect.position - transform.origin / transform.get_scale()
		color_rect.size = rect.size / transform.get_scale()
	
	
