extends Area2D

export (int) var speed
export (int, -1, 1) var direction

func _ready() -> void:
	if connect("area_entered", self, "_on_area_entered"):
		print("BUG: function 'connect' failed")

func _physics_process(delta: float) -> void:
	global_position.y += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("goodies"):
		return
	queue_free()
