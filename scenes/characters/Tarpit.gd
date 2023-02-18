extends Area2D

func _on_Tarpit_area_entered(area: Area2D) -> void:
	if area == self.owner or area.is_in_group("deadzones") or area.is_in_group("lasers"):
		return
	area.speed /= 1.5


func _on_Tarpit_area_exited(area: Area2D) -> void:
	if area == self.owner or area.is_in_group("deadzones") or area.is_in_group("lasers"):
		return
	area.speed *= 1.5
