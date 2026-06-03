class_name DNGameManager

extends Node

enum game_state {
	NONE = -1,
	StartCoding,
	CodeRunning,
	GameOver,
	Victory,
}

var actual_state: game_state = game_state.NONE
@export var chronometer_in_second: float = 30
@export var player_bot_life: int = 3
@export var wave_spawn_point: Array[Vector3]
@export var cooldown_respawn_enemy: float = 5
@export var player_bot: Node
@export var player_collider: CollisionShape3D

#var enemies_node: Array[Enemy]
#var enemy_pool_system: PoolSystem

func _ready() -> void:
	actual_state = game_state.StartCoding
	if !player_bot:
		return
	if player_collider:
		return
	for child in player_bot:
		if child is not CollisionObject3D:
			continue
		else:
			player_collider = child
			return

func _process(delta: float) -> void:
	match actual_state:
		game_state.NONE:
			pass
		game_state.StartCoding:
			start_game()
		game_state.CodeRunning:
			start_battle_bot()
		game_state.GameOver:
			game_over()
		game_state.Victory:
			victory()
		_:
			pass

func start_game():
	pass

func start_battle_bot():
	if player_bot_life < 0:
		actual_state = game_state.GameOver
	if chronometer_in_second < 0:
		actual_state = game_state.Victory
	#for enemy in enemies_node:
		#pass
		#if enemy.isDead()
		#enemies_node.removeItem(enemy)
	#if enemies_node.size() >= 2:
		#return
	#var enemy: node = enemy_pool_system.GetItem(item)
	

func game_over():
	pass

func victory():
	pass

func on_run_pressed():
	actual_state = game_state.CodeRunning

func on_retry_pressed():
	actual_state = game_state.StartCoding
	player_bot_life = 3

func get_enemies(enemies_node: Array[Node]):
	self.enemies_node = enemies_node

func get_damaged():
	player_bot_life -= player_bot_life
