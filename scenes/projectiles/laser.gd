extends Area2D

@export var speed : int
@export_range(-1, 1) var direction : int

func _physics_process(delta: float) -> void:
	global_position.y += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("goodies"):
		return
	queue_free()
