extends Node

@export var enemy: Node3D

@onready var spawn_timer = $SpawnTimer
@onready var kill_timer = $KillTimer

var enemy_active = false
var player_hiding = false
var player_dead = false


func _ready():
	enemy.visible = false
	
	spawn_timer.timeout.connect(_on_spawn_timeout)
	kill_timer.timeout.connect(_on_kill_timeout)
	
	spawn_timer.start()   # Start the 30s cycle


# =========================================================
# SPAWN EVERY 30 SECONDS
# =========================================================

func _on_spawn_timeout():
	if player_dead:
		return
	
	if enemy_active:
		return   # Prevent double spawn
	
	enemy_active = true
	player_hiding = false
	
	enemy.visible = true
	_place_enemy_in_front()
	
	kill_timer.start()


# =========================================================
# HIDE GESTURE
# =========================================================

func on_hide_gesture():
	if player_dead:
		return
	
	if enemy_active:
		player_hiding = true
		enemy_active = false
		
		kill_timer.stop()
		enemy.visible = false
		
		print("You hid successfully.")


# =========================================================
# FAILURE
# =========================================================

func _on_kill_timeout():
	if enemy_active and not player_hiding:
		kill_player()


func kill_player():
	if player_dead:
		return
	
	player_dead = true
	
	spawn_timer.stop()   # Stop future spawns
	enemy.visible = false
	
	await get_tree().create_timer(1.5).timeout
	
	var death_screen = preload("res://bicho/death_screen.tscn").instantiate()
	get_tree().root.add_child(death_screen)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# =========================================================
# POSITIONING
# =========================================================

func _place_enemy_in_front():
	var cam = get_viewport().get_camera_3d()
	if cam:
		var forward = -cam.global_transform.basis.z
		enemy.global_position = cam.global_position + forward * 2.5 + Vector3(0, -2.5, 0)
		enemy.rotation = cam.global_rotation + Vector3(0, PI, 0)
