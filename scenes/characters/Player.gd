extends Area2D

signal spawn_laser(scene, location)
signal took_damage()
signal update_lifeboard(amount)
signal death()
signal game_over()

export (int) var hp
export (int) var speed

onready var Laser := preload("res://scenes/projectiles/PlayerLaser.tscn")
onready var muzzle := $Muzzle
onready var left_wing := $LeftWing
onready var right_wing := $RightWing
onready var powerup_timer := $PowerUpTimer

var has_power_up := false
var input_vector := Vector2.ZERO

func _ready() -> void:
	if connect("area_entered", self, "_on_area_entered"):
		print("BUG: function 'connect' failed")

func _physics_process(delta: float) -> void:
	input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	global_position += input_vector * speed * delta
	global_position.x = clamp(global_position.x, 0, 540)
	global_position.y = clamp(global_position.y, 0, 888)
	if Input.is_action_just_pressed("ui_select"):
		if has_power_up:
			emit_signal("spawn_laser", Laser, [left_wing.global_position, muzzle.global_position, right_wing.global_position])
		else:
			emit_signal("spawn_laser", Laser, [muzzle.global_position])


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("goodies"):
		if area.is_in_group("lifeup"):
			hp += 1
			area.queue_free()
			emit_signal("update_lifeboard", hp)
		elif area.is_in_group("powerup"):
			has_power_up = true
			area.queue_free()
			powerup_timer.start()
	else:
		hp -= 1
		emit_signal("took_damage")
		emit_signal("update_lifeboard", hp)
		if hp <= 0:
			queue_free()
			emit_signal("death")
			emit_signal("game_over")

func _on_PowerUpTimer_timeout() -> void:
	has_power_up = false
