@tool
extends Node2D


var _parent: Control
func _enter_tree():
	_parent = _get_parent_control()
	if _parent and not _parent.resized.is_connected(_reposition):
		_parent.resized.connect(_reposition)
	
	_reposition()
	
func _exit_tree():
	if _parent and _parent.resized.is_connected(_reposition):
		_parent.resized.disconnect(_reposition)

func _get_parent_control() -> Control:
	var parent = get_parent()
	if not parent is Control: return
	return parent as Control

func _reposition():
	if _parent:
		position = _parent.size / 2.0
