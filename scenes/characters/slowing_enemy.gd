extends "enemy.gd"

func _on_tar_pit_area_entered(area):
	if area == self.owner or area.is_in_group("deadzones") or area.is_in_group("lasers") or area.is_in_group("goodies"):
		return
	area.speed /= 1.5

func _on_tar_pit_area_exited(area):
	if area == self.owner or area.is_in_group("deadzones") or area.is_in_group("lasers") or area.is_in_group("goodies"):
		return
	area.speed *= 1.5
