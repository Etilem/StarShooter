extends Area2D

signal spawn_laser(scene, location)
signal took_damage()
signal update_lifeboard(val)
signal death(location)
signal game_over()

export (int) var hp = 0
export (int) var speed = 0

onready var Laser = preload("res://projectiles/PlayerLaser.tscn")
onready var muzzle = $Muzzle

var input_vector = Vector2.ZERO

func _physics_process(delta: float) -> void:
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	global_position.x += input_vector.x * speed * delta
	global_position.y += input_vector.y * speed * delta
	global_position.x = clamp(global_position.x, 0, 540)
	global_position.y = clamp(global_position.y, 0, 960)
	if Input.is_action_just_pressed("shoot"):
		emit_signal("spawn_laser", Laser, muzzle.global_position)

func _on_area_entered(_area: Area2D) -> void:
	hp -= 1
	emit_signal("took_damage")
	emit_signal("update_lifeboard", hp)
	if hp <= 0:
		queue_free()
		emit_signal("death", global_position)
		emit_signal("game_over")

func _on_start() -> void:
	emit_signal("update_lifeboard", hp)
