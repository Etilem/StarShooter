extends Area2D

export (int) var speed
export (int, -1, 1) var direction

func _physics_process(delta: float) -> void:
	global_position.y += direction * speed * delta

func _on_area_entered(_area: Area2D) -> void:
	queue_free()
