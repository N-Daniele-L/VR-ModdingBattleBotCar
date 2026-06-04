@tool
class_name CSProjectileSpawner
extends Node3D

## Émis un projectile configuré vient d'être extrait du pool.
signal projectile_spawned(projectile: CSProjectile)
@export var projectile_pool: NCARPoolSystem

func spawn_projectile(pool_type: String, damage: int, lifetime: float, speed: float, trajectory_type: int, target_pos: Vector3, color: Color) -> void:
	if Engine.is_editor_hint():
		return
	var projectile = projectile_pool.get_object_from_pool() as CSProjectile
	#get_tree().current_scene.add_child(projectile) 
	projectile.global_position = global_position
	projectile.initialize_projectile(damage,lifetime,speed,trajectory_type,target_pos,color)
	projectile_spawned.emit(projectile)
	#var pool_manager = get_node_or_null("/root/CSPoolManager") as CSPoolManager
	#if pool_manager == null:
		#return
		#
	#var bullet = pool_manager.get_from_pool(pool_type) as CSProjectile
	#if bullet != null:
		#get_tree().current_scene.add_child(bullet)
		#bullet.global_position = global_position
		#bullet.initialize_projectile(damage, lifetime, speed, trajectory_type, target_pos, color)
		#projectile_spawned.emit(bullet)
	
