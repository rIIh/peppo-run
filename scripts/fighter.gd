extends Node


class_name Fighter

var smoke_particles = preload("res://prefabs/fighting_particles.tscn")

var enabled: bool = true

@export
var body: Area2D

@export
var sprite_to_hide: Sprite2D

@onready
var parent: Node2D = get_parent()

var _active: bool = false
var _fighting_with: Fighter = null
var _fight_start_position: Vector2

var is_fighting: bool :
	get: return _fighting_with != null


signal will_enter_to_fight
signal entered_to_fight


func _ready():
	body.body_entered.connect(_handle_body_entered)


func _handle_body_entered(body: Node2D):
	var other_fighter = NodeUtilities.get_child_of_type(body, Fighter)
	if other_fighter:
		fight(other_fighter)


var _move_tween: Tween
func fight(other_fighter: Fighter):
	if is_fighting or other_fighter == self:
		return

	_fight_start_position = parent.global_position
	if other_fighter.is_fighting and other_fighter._fighting_with == self:
		_fighting_with = other_fighter

		var target_position = (_fight_start_position + other_fighter._fight_start_position) / 2

		will_enter_to_fight.emit()

		_move_to(target_position)
	elif not other_fighter.is_fighting and enabled and other_fighter.enabled:
		_fighting_with = other_fighter
		var is_second = other_fighter.is_fighting

		other_fighter.fight(self)

		var target_position = (_fight_start_position + other_fighter._fight_start_position) / 2

		will_enter_to_fight.emit()

		_move_to(target_position)

		var smoke = smoke_particles.instantiate()
		smoke.position = target_position + Vector2.UP * 40
		add_child(smoke)


func _move_to(position: Vector2):
	if _move_tween:
		_move_tween.kill()

	_move_tween = create_tween()
	_move_tween.tween_method(func(v): parent.global_translate(v - parent.global_position), parent.global_position, position, .125).set_ease(Tween.EASE_IN)
	_move_tween.tween_callback(
		func(): 
			entered_to_fight.emit()
			if sprite_to_hide:
				sprite_to_hide.visible = false
	)
