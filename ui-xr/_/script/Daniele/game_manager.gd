class_name DNGameManager

extends Node

enum game_state {
	NONE = -1,
	StartCoding,
	CodeRunning,
	GameOver,
	Victory,
}


@export var chronometer_in_second: float = 30
@export var player_bot_life: int = 3
@export var wave_spawn_point: Array[Vector3]
@export var cooldown_respawn_enemy: float = 1
@export var player_bot: Node
@export var enemy_pool: NCARPoolSystem
var chrono : float
var enemies_node: Array[Node3D]
var is_enemy_killed : bool
var spawn_enemy: bool
var timer_spawn_enemy: float = 1

@export_group("Debug State")
@export var actual_state: game_state = game_state.NONE

func _ready() -> void:
	actual_state = game_state.StartCoding
	chrono = chronometer_in_second
	timer_spawn_enemy = cooldown_respawn_enemy

func _process(delta: float) -> void:
	match actual_state:
		game_state.NONE:
			pass
		game_state.StartCoding:
			start_game()
		game_state.CodeRunning:
			start_battle_bot()
			cooldown_enemy(delta)
			chronometer_in_second -= delta
			if player_bot_life < 0:
				actual_state = game_state.GameOver
			if chronometer_in_second < 0:
				actual_state = game_state.Victory
		game_state.GameOver:
			game_over()
		game_state.Victory:
			victory()
		_:
			pass

func start_game():
	pass

func start_battle_bot():
	if enemies_node.size() <= 2:
		is_enemy_killed = true
		if !spawn_enemy:
			return
		var enemy_created = enemy_pool.get_object_from_pool()
		var rand = randi_range(0,wave_spawn_point.size() - 1)
		enemy_created.global_position = wave_spawn_point[rand]
		enemies_node.append(enemy_created)
		is_enemy_killed = false
		spawn_enemy = false

func cooldown_enemy(delta: float):
	if !is_enemy_killed:
		return
	timer_spawn_enemy -= delta
	if timer_spawn_enemy < 0:
		spawn_enemy = true
		timer_spawn_enemy = cooldown_respawn_enemy

func game_over():
	pass

func victory():
	pass

func on_run_pressed():
	#don't know if game_manager should check validation of code modded or if modding script do it
	actual_state = game_state.CodeRunning

func on_retry_pressed():
	actual_state = game_state.StartCoding
	chronometer_in_second = chrono
	player_bot_life = 3

func get_damaged():
	player_bot_life -= player_bot_life

func enemy_killed(enemy: Node3D):
	enemies_node.erase(enemy)
	
