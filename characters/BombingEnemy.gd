extends "res://characters/Enemy.gd"

signal spawn_laser(scene, location)

onready var Laser = preload("res://projectiles/EnemyLaser.tscn")
onready var muzzle = $Muzzle

func _on_timeout() -> void:
	emit_signal("spawn_laser", Laser, muzzle.global_position)
