extends Node2D

@export var enemies : Array[PackedScene]
@export var goodies : Array[PackedScene]

@onready var level := $Level
@onready var spawn_locations := $Level/SpawnZones/SpawnLocations
@onready var spawn_timer := $Level/SpawnZones/SpawnTimer
@onready var goodies_timer := $Level/SpawnZones/GoodiesTimer
@onready var player_laser_sound := $Sounds/PlayerLaser
@onready var enemy_laser_sound := $Sounds/EnemyLaser
@onready var hit_sound := $Sounds/HitSound
@onready var explode_sound := $Sounds/ExplodeSound
@onready var score_board := $HUD/Score
@onready var life_board := $HUD/Lifeboard
@onready var the_end := $HUD/TheEnd
@onready var final_score := $HUD/TheEnd/FinalScore
@onready var restart_button := $HUD/TheEnd/Button
@onready var waves := $HUD/Waves
@onready var anim := $Background/AnimationPlayer

var spawns : Array[Node]
var is_player_alive := true
var waves_num := 1
var score := 0

func _ready():
	randomize()
	spawns = spawn_locations.get_children()
	spawn_timer.connect("timeout", _on_spawn_timer_timeout)
	goodies_timer.connect("timeout", _on_goodies_timer_timeout)
	restart_button.connect("pressed", _on_restart_button_pressed)

func _on_player_spawn_laser(scene, locations):
	_spawn_laser(scene, locations)
	player_laser_sound.play()

func _on_enemy_spawn_laser(scene, locations):
	_spawn_laser(scene, locations)
	enemy_laser_sound.play()

func _spawn_laser(scene, locations):
	for loc in locations:
		var laser = scene.instantiate()
		laser.global_position = loc
		level.add_child(laser)

func _on_spawn_timer_timeout():
	var enemy =  enemies[randi()%enemies.size()].instantiate()
	enemy.global_position = spawns[randi()%spawns.size()].global_position
	if enemy.has_signal("spawn_laser"):
		enemy.connect("spawn_laser", _on_enemy_spawn_laser)
	enemy.connect("took_damage", _on_took_damage)
	enemy.connect("death", _on_death)
	enemy.connect("update_score", _on_update_score)
	level.add_child(enemy)
	spawn_timer.wait_time -= .1
	if spawn_timer.wait_time < 0.1:
		randomize()
		waves_num += 1
		anim.play("flash")
		spawn_timer.wait_time = randf_range(3.0/log(waves_num+1), 3.0)
		waves.text = "wave #" + str(waves_num)

func _on_goodies_timer_timeout():
	var goodie = goodies[randi()%goodies.size()].instantiate()
	goodie.global_position = spawns[randi()%spawns.size()].global_position
	level.add_child(goodie)
	goodies_timer.wait_time = randf_range(30.0/log(waves_num+1), 30.0)

func _on_took_damage():
	hit_sound.play()

func _on_death(location):
	explode_sound.play()
	var explosion = preload("res://scenes/characters/explosion.tscn").instantiate()
	explosion.global_position = location
	level.add_child(explosion)
	explosion.self_modulate = Color(randf(),randf(),randf())
	explosion.emitting = true

func _on_update_score(amount):
	if is_player_alive:
		score += amount
		score_board.text = "SCORE: " + str(score)

func _on_game_over():
	is_player_alive = false
	life_board.hide()
	final_score.text = "FINAL SCORE: " + str(score) + " * " + str(waves_num) + " = " + str(score*waves_num)
	the_end.show()

func _on_update_lifeboard(amount):
	life_board.size.x = amount * 37

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/world/world.tscn")
