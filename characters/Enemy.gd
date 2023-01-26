extends Area2D

signal took_damage()
signal death(location)
signal update_score(val)

export (int) var value = 0
export (int) var hp = 0
export (int) var speed = 0

func _physics_process(delta: float) -> void:
	global_position.y += speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("deadzones"):
		queue_free()
	elif area.is_in_group("enemies"):
		pass
	else:
		hp -= 1
		emit_signal("took_damage")
		if hp <= 0:
			queue_free()
			emit_signal("death", global_position)
			emit_signal("update_score", value)
