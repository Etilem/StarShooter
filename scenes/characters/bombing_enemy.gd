extends "enemy.gd"

signal spawn_laser(scene, locations)

@onready var Laser = preload("res://scenes/projectiles/enemy_laser.tscn")
@onready var muzzle := $Muzzle
@onready var bomb_timer := $BombingTimer

func _on_bombing_timer_timeout():
	emit_signal("spawn_laser", Laser, [muzzle.global_position])
	bomb_timer.wait_time = randf_range(1.0, 2.0)
