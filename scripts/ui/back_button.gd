extends MarginContainer


@onready
var router: Router = NodeUtilities.get_parent_of_type(self, Router)


func _ready():
	%circle_button.pressed.connect(router.pop)
	
	_check_visibility()
	router.popped.connect(_check_visibility)
	router.pushed.connect(_check_visibility)


var _tween: Tween
func _check_visibility():
	if _tween:
		_tween.kill()
		
	_tween = create_tween().set_parallel().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	if router.can_pop():
		_tween.tween_property(self, "scale", Vector2.ONE, .125)
		_tween.tween_property(self, "rotation", 0, .075).set_delay(.035)
	else:
		_tween.tween_property(self, "scale", Vector2.ZERO, .125)
		_tween.tween_property(self, "rotation", -PI / 4, .075).set_delay(.035)
