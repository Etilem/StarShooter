extends Node2D

signal start()

export (Array, PackedScene) var enemies

onready var hit_sound = $HitSound
onready var explode_sound = $ExplodeSound
onready var spawn_zones = $SpawnZones
onready var score_label = $HUD/Score
onready var game_over_label = $HUD/GameOver
onready var lifeboard = $HUD/LifeBoard

var player_dead = false
var score = 0
var spawn_locations = null

func _ready() -> void:
	randomize()
	_on_update_score(0)
	spawn_locations = spawn_zones.get_children()
	emit_signal("start")

func _on_SpawnTimer_timeout() -> void:
	var rand_scene = enemies[randi()%enemies.size()]
	var enemy = rand_scene.instance()
	var rand_index = randi()%spawn_locations.size()
	enemy.global_position = spawn_locations[rand_index].global_position
	if enemy.has_signal("spawn_laser"):
		enemy.connect("spawn_laser", self, "_on_spawn_laser")
	enemy.connect("took_damage", self, "_on_took_damage")
	enemy.connect("update_score", self, "_on_update_score")
	enemy.connect("death", self, "_on_death")
	add_child(enemy)

func _on_spawn_laser(scene, location) -> void:
	var laser = scene.instance()
	var sfx = laser.get_node("SFX")
	laser.global_position = location
	sfx.play()
	add_child(laser)

func _on_took_damage() -> void:
	hit_sound.play()

func _on_update_score(val) -> void:
	score += val
	if not player_dead:
		score_label.text = "SCORE: " + str(score)

func _on_death(_location) -> void:
	explode_sound.play()

func _on_game_over() -> void:
	player_dead = true
	game_over_label.visible = true
	lifeboard.visible = false

func _on_update_lifeboard(val) -> void:
	lifeboard.rect_size.x = 37 * val
