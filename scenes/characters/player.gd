extends Area2D

signal player_spawn_laser(scene, locations)
signal took_damage
signal update_lifeboard(amount)
signal death(location)
signal game_over

@export var speed : int
@export var hp : int

@onready var Laser := preload("res://scenes/projectiles/player_laser.tscn")
@onready var muzzle := $Muzzle
@onready var left_wing := $LeftWing
@onready var right_wing := $RightWing
@onready var power_up_timer := $PowerUpTimer

var has_power_up := false
var input_vector : Vector2

func _physics_process(delta: float) -> void:
	input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	global_position += input_vector * speed * delta
	global_position.x = clamp(global_position.x, 0, 540)
	global_position.y = clamp(global_position.y, 0, 900)
	if Input.is_action_just_pressed("ui_select"):
		if has_power_up:
			emit_signal("player_spawn_laser", Laser, [left_wing.global_position, muzzle.global_position, right_wing.global_position])
		else:
			emit_signal("player_spawn_laser", Laser, [muzzle.global_position])

func _on_area_entered(area):
	if area.is_in_group("goodies"):
		if area.is_in_group("lifeup"):
			hp += 1
			area.queue_free()
			emit_signal("update_lifeboard", hp)
		elif area.is_in_group("powerup"):
			has_power_up = true
			area.queue_free()
			power_up_timer.start()
	else:
		hp -= 1
		emit_signal("took_damage")
		emit_signal("update_lifeboard", hp)
		if hp <= 0:
			queue_free()
			emit_signal("death", global_position)
			emit_signal("game_over")

func _on_power_up_timer_timeout():
	has_power_up = false
