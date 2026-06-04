@tool
class_name CSEnemyAttack
extends Node

## Émis au moment de la génération physique du tir de l'ennemi.
signal enemy_projectile_fired(spawn_position: Vector3, target_position: Vector3)

@export var attack_range: float = 12.0
@export var attack_cooldown: float = 1.5

var cooldown_timer: float = 0.0

func is_target_in_range(enemy_pos: Vector3, target_pos: Vector3) -> bool:
	return enemy_pos.distance_to(target_pos) <= attack_range

func process_combat_loop(target_pos: Vector3, delta: float) -> void:
	cooldown_timer += delta
	if cooldown_timer >= attack_cooldown:
		var parent_node = get_parent() as Node3D
		if parent_node != null:
			enemy_projectile_fired.emit(parent_node.global_position, target_pos)
		cooldown_timer = 0.0
