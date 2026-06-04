@tool
class_name CSProjectileSpawner
extends Node3D

## Émis un projectile configuré vient d'être extrait du pool.
signal projectile_spawned(projectile: CSProjectile)

func spawn_projectile(pool_type: String, damage: int, lifetime: float, speed: float, trajectory_type: int, target_pos: Vector3, color: Color) -> void:
	if Engine.is_editor_hint():
		return
	var pool_manager = get_node_or_null("/root/CSPoolManager") as CSPoolManager
	if pool_manager == null:
		return
		
	var bullet = pool_manager.get_from_pool(pool_type) as CSProjectile
	if bullet != null:
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.initialize_projectile(damage, lifetime, speed, trajectory_type, target_pos, color)
		projectile_spawned.emit(bullet)
