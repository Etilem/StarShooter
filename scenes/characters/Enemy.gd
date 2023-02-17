extends Area2D

signal took_damage()
signal death()
signal update_score(amount)

export (int) var value
export (int) var hp
export (int) var speed
export (int, -1, 1) var direction

var rand_slide : float

func _ready() -> void:
	if connect("area_entered", self, "_on_area_entered"):
		print("BUG: function 'connect' failed")

func _physics_process(delta: float) -> void:
	global_position.y += direction * speed * delta
	global_position.x += rand_slide * speed * delta
	global_position.x = clamp(global_position.x, 0, 540)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		return
	elif area.is_in_group("deadzones"):
		queue_free()
	else:
		hp -= 1
		emit_signal("took_damage")
		if hp <= 0:
			queue_free()
			emit_signal("death")
			emit_signal("update_score", value)

func _on_SlideTimer_timeout() -> void:
	rand_slide = rand_range(-1.0, 1.0)

