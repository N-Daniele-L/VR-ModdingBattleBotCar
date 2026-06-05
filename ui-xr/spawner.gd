class_name NCARSpawner
extends Node3D

@export var spawn_pos : Array[Node3D]
@export var poolsystem : NCARPoolSystem

@export var time_between_spawn : float = 5
var chrono : float

var isplaying: bool

var max_enemy : int = 2
var enemy_spawned : Array[Node3D]



func _process(delta: float) -> void:
	if not isplaying:
		return
	if enemy_spawned.size() >= max_enemy:
		return	
	
	if chrono >= time_between_spawn:
		var enemy = _spawn_enemy()
		var rand = randi_range(0, 1)
		enemy.global_position = spawn_pos[rand].global_position
		enemy_spawned.append(enemy)
		chrono = 0
	chrono += delta

func _spawn_enemy() -> Node3D:
	return poolsystem.get_object_from_pool()

func _kill_enemy(enemy : Node3D) -> void:
	enemy.visible = false
	enemy_spawned.erase(enemy)

func set_spawner(play : bool)-> void:
	isplaying = play
	if play:
		chrono = time_between_spawn
	else:
		_reset_spawner()

func _reset_spawner() ->void:
	for enemy in enemy_spawned:
		enemy.visible = false
	enemy_spawned.clear()
