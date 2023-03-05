extends Area2D

signal took_damage
signal death(location)
signal update_score(amount)

@export var value : int
@export var speed : int
@export var hp : int
@export_range(-1, 1) var direction : int

@onready var slide_timer := $SlideTimer

var rand_slide : float

func _ready():
	slide_timer.wait_time = randf_range(.25, 1.5)

func _physics_process(delta):
	global_position.y += direction * speed * delta
	global_position.x += rand_slide * speed * delta
	global_position.x = clamp(global_position.x, 0, 540)

func _on_area_entered(area):
	if area.is_in_group("enemies") or area.is_in_group("goodies"):
		return
	elif area.is_in_group("deadzones"):
		queue_free()
	else:
		hp -= 1
		emit_signal("took_damage")
		if hp <= 0:
			queue_free()
			emit_signal("death", global_position)
			emit_signal("update_score", value)

func _on_slide_timer_timeout():
	rand_slide = randf_range(-1.0, 1.0)
	slide_timer.wait_time = randf_range(.25, 1)
