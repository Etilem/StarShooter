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
		emit_signal("spawn_laser", Laser, muzzle.global_position)


func _on_area_entered(_area: Area2D) -> void:
	hp -= 1
	emit_signal("took_damage")
	emit_signal("update_lifeboard", hp)
	if hp <= 0:
		queue_free()
		emit_signal("death")
		emit_signal("game_over")
