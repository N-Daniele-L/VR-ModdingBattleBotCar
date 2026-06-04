@tool
class_name CSEnemySpawnDirector
extends Node3D

## Émis lorsque le quota d'ennemis est rétabli avec succès.
signal quota_verified(active_count: int)

@export var spawn_points: Array[Marker3D] = []

var active_enemies: Array[CSEnemyController] = []
const MAX_SIMULTANEOUS_ENEMIES: int = 2

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	enforce_enemy_quota()
	var x = request_enemy_from_pool()
	x.visible = true

func enforce_enemy_quota() -> void:
	while active_enemies.size() < MAX_SIMULTANEOUS_ENEMIES:
		var new_enemy = request_enemy_from_pool()
		if new_enemy != null:
			active_enemies.append(new_enemy)
		else:
			break
	quota_verified.emit(active_enemies.size())

func request_enemy_from_pool() -> CSEnemyController:
	var pool_manager = get_node_or_null("/root/CSPoolManager") as CSPoolManager
	if pool_manager == null:
		return null
		
	var enemy = pool_manager.get_from_pool("BasicEnemy") as CSEnemyController
	if enemy == null:
		return null
		
	var random_point = Vector3.ZERO
	if spawn_points.size() > 0:
		var index = randi() % spawn_points.size()
		if spawn_points[index] != null:
			random_point = spawn_points[index].global_position
			
	if enemy.get_parent() == null:
		add_child(enemy)
		
	if not enemy.enemy_lifecycle_ended.is_connected(_on_enemy_lifecycle_ended):
		enemy.enemy_lifecycle_ended.connect(_on_enemy_lifecycle_ended)
		
	var attack_comp = enemy.get_node_or_null("EnemyAttack") as CSEnemyAttack
	if attack_comp != null and not attack_comp.enemy_projectile_fired.is_connected(_on_enemy_shoot):
		attack_comp.enemy_projectile_fired.connect(_on_enemy_shoot)
		
	enemy.activate_enemy(random_point)
	return enemy

func _on_enemy_lifecycle_ended(enemy_instance: CSEnemyController) -> void:
	if active_enemies.has(enemy_instance):
		active_enemies.erase(enemy_instance)
		
	if enemy_instance.enemy_lifecycle_ended.is_connected(_on_enemy_lifecycle_ended):
		enemy_instance.enemy_destroyed.disconnect(_on_enemy_lifecycle_ended) if enemy_instance.has_signal("enemy_destroyed") else enemy_instance.enemy_lifecycle_ended.disconnect(_on_enemy_lifecycle_ended)
		
	var attack_comp = enemy_instance.get_node_or_null("EnemyAttack") as CSEnemyAttack
	if attack_comp != null and attack_comp.enemy_projectile_fired.is_connected(_on_enemy_shoot):
		attack_comp.enemy_projectile_fired.disconnect(_on_enemy_shoot)
		
	var pool_manager = get_node_or_null("/root/CSPoolManager") as CSPoolManager
	if pool_manager != null:
		pool_manager.return_to_pool(enemy_instance)
		
	enforce_enemy_quota()

func _on_enemy_shoot(spawn_pos: Vector3, target_pos: Vector3) -> void:
	var pool_manager = get_node_or_null("/root/CSPoolManager") as CSPoolManager
	if pool_manager == null:
		return
	var bullet = pool_manager.get_from_pool("EnemyProjectile") as CSProjectile
	if bullet != null:
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = spawn_pos
		bullet.initialize_projectile(1, 3.0, 15.0, 0, target_pos, Color(1, 0, 0))
