class_name CSEnemyMovement
extends Node

var node_pos: Node3D

@export var movement_speed: float = 4.0
func _process(delta: float) -> void:
	node_pos = find_closest_player_target()
	var vector : Vector3 = node_pos.global_position
	execute_movement(self.get_parent(),vector,delta)

func find_closest_player_target() -> Node3D:
	var closest_target: Node3D = null
	var shortest_distance: float = 99999.0
	var targets = get_tree().get_nodes_in_group("PlayerTargets")
	
	for potential_target in targets:
		var node_3d = potential_target as Node3D
		if node_3d != null and is_instance_valid(node_3d):
			var distance = get_parent().global_position.distance_to(node_3d.global_position)
			if distance < shortest_distance:
				shortest_distance = distance
				closest_target = node_3d
	return closest_target

func execute_movement(actor: CharacterBody3D, target_pos: Vector3, _delta: float) -> void:
	var current_pos = actor.global_position
	var direction = (Vector3(target_pos.x, current_pos.y, target_pos.z) - current_pos).normalized()
	if direction.length_squared() > 0.001:
		actor.look_at(Vector3(target_pos.x, current_pos.y, target_pos.z), Vector3.UP)
	actor.velocity = direction * movement_speed
	actor.move_and_slide()
