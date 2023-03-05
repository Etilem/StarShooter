extends Area2D

@export var speed : int

func _physics_process(delta):
	global_position.y += speed * delta

func _on_area_entered(area):
	if area.is_in_group("deadzones"):
		queue_free()
