extends Node2D

export (Array, PackedScene) var enemies

onready var level := $Level
onready var player := $Level/Player
onready var spawn_locations := $Level/SpawnZones/Locations
onready var spawn_timer := $Level/SpawnZones/SpawnTimer
onready var hit_sound := $Sounds/HitSound
onready var explode_sound := $Sounds/ExplodeSound
onready var score_board := $HUD/Score
onready var life_board := $HUD/Lifeboard
onready var game_over := $HUD/GameOver

var spawns : Array
var score := 0
var is_player_alive := true

func _ready() -> void:
	randomize()
	spawns = spawn_locations.get_children()
	_safe_connect(spawn_timer, "timeout", self, "_on_timeout")
	_safe_connect(player, "spawn_laser", self, "_on_spawn_laser")
	_safe_connect(player, "took_damage", self, "_on_took_damage")
	_safe_connect(player, "update_lifeboard", self, "_on_update_lifeboard")
	_safe_connect(player, "death", self, "_on_death")
	_safe_connect(player, "game_over", self, "_on_game_over")

func _on_timeout() -> void:
	var enemy = enemies[randi()%enemies.size()].instance()
	enemy.global_position = spawns[randi()%spawns.size()].global_position
	if enemy.has_signal("spawn_laser"):
		_safe_connect(enemy, "spawn_laser", self, "_on_spawn_laser")
	_safe_connect(enemy, "took_damage", self, "_on_took_damage")
	_safe_connect(enemy, "death", self, "_on_death")
	_safe_connect(enemy, "update_score", self, "_on_update_score")
	level.add_child(enemy)

func _on_spawn_laser(scene, location) -> void:
	var laser = scene.instance()
	laser.global_position = location
	laser.get_node("SFX").play()
	level.add_child(laser)

func _on_took_damage() -> void:
	hit_sound.play()

func _on_update_lifeboard(amount) -> void:
	life_board.rect_size.x = amount * 37

func _on_death() -> void:
	explode_sound.play()

func _on_update_score(amount) -> void:
	if is_player_alive:
		score += amount
		score_board.text = "SCORE: " + str(score)

func _on_game_over() -> void:
	is_player_alive = false
	game_over.show()
	life_board.hide()

func _safe_connect(who, what, to, function) -> void:
	if who.connect(what, to, function):
		print("BUG: function 'connect' failed")
