@tool
extends Resource

class_name EdgeInsets

@export
var left: float :
	set(value):
		if (left != value):
			emit_changed()
		left = value

@export
var top: float :
	set(value):
		if (top != value):
			emit_changed()
		top = value

@export
var right: float :
	set(value):
		if (right != value):
			emit_changed()
		right = value

@export
var bottom: float :
	set(value):
		if (bottom != value):
			emit_changed()
		bottom = value


func _init(left := 0, top := 0, right := 0, bottom := 0):
	self.left = left
	self.top = top
	self.right = right
	self.bottom = bottom


static var zero: EdgeInsets :
	get: return EdgeInsets.new(0, 0, 0, 0)


static func from_rect_inside_rect(inner_rect: Rect2, outer_rect: Rect2):
	var left = inner_rect.position.x - outer_rect.position.x
	var top = inner_rect.position.y - outer_rect.position.y
	var right = outer_rect.size.x - left - inner_rect.size.x
	var bottom = outer_rect.size.y - top - inner_rect.size.y

	return EdgeInsets.new(left, top, right, bottom)


func only_positive() -> EdgeInsets:
	return EdgeInsets.new(
		left if left > 0 else 0,
		top if top > 0 else 0,
		right if right > 0 else 0,
		bottom if bottom > 0 else 0,
	)

static func divide(insets: EdgeInsets, value: float) -> EdgeInsets:
	return EdgeInsets.new(
		insets.left / value,
		insets.top / value,
		insets.right / value,
		insets.bottom / value
	)

static func take_max(left: EdgeInsets, right: EdgeInsets) -> EdgeInsets:
	return EdgeInsets.new(
		max(left.left, right.left),
		max(left.top, right.top),
		max(left.right, right.right),
		max(left.bottom, right.bottom),
	)

static func take_min(left: EdgeInsets, right: EdgeInsets) -> EdgeInsets:
	return EdgeInsets.new(
		min(left.left, right.left),
		min(left.top, right.top),
		min(left.right, right.right),
		min(left.bottom, right.bottom),
	)

func _to_string():
	return "(l: %s, t: %s, r: %s, b: %s)" % [left, top, right, bottom]
