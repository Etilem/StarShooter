extends Area2D

export var speed : int

var direction := 1

func _physics_process(delta: float) -> void:
	global_position.y += direction * speed * delta
