extends Area2D

export (int) var speed = 0
export (int, -1, 1) var direction = 0

func _physics_process(delta: float) -> void:
	global_position.y += direction * speed * delta

func _on_area_entered(_area: Area2D) -> void:
	queue_free()
