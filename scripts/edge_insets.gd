extends Resource

class_name EdgeInsets

@export
var left: float

@export
var top: float

@export
var right: float

@export
var bottom: float


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
