extends "Enemy.gd"

signal spawn_laser(scene, location)

onready var Laser := preload("res://scenes/projectiles/EnemyLaser.tscn")
onready var muzzle := $Muzzle
onready var bomb_timer := $BombingTimer

func _ready() -> void:
	if bomb_timer.connect("timeout", self, "_on_timeout"):
		print("BUG: function 'connect' failed")

func _on_timeout() -> void:
	emit_signal("spawn_laser", Laser, muzzle.global_position)
	bomb_timer.wait_time = rand_range(1.0, 2.0)
