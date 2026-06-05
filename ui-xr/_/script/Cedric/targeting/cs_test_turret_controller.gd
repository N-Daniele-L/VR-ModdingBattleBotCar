@tool
class_name CSTestTurretController
extends Node3D

## Émis lorsque le controleur radar valide la nécessité d'effectuer un tir.
signal shot_requested(target_position: Vector3)
## Émis lorsqu'une nouvelle cible prioritaire est verrouillée par le radar.
signal target_acquired(target: Node3D)

@export var enemies_locked: Array[Node3D]

func add_one_enemy_to_ennemies_locked(enemy: Node3D):
	enemies_locked.append(enemy)
	targets_to_aim.append(enemy)
	
func remove_enemy_dead_from_locked_enemy(enemy: Node3D):
	var index = enemies_locked.find(enemy)
	enemies_locked.erase(enemy)
	targets_to_aim.remove_at(index)
	
@export var targets_to_aim: Array[Node3D]

func replace_pos_every_frame(index: int,pos_node: Node3D):
	targets_to_aim.set(index,pos_node)

@export var automatic_fire: bool = true

var fire_timer: float = 0.0
var current_target: Node3D = null

func _process(delta: float) -> void:
	_find_closest_target()
	if current_target == null:
		return
		
	var target_pos = current_target.global_position
	look_at(target_pos, Vector3.UP)
	
	if automatic_fire:
		fire_timer += delta
		var weapon_manager = get_node_or_null("WeaponPoint") as CSWeaponManager
		if weapon_manager != null:
			if fire_timer >= weapon_manager.fire_rate:
				shot_requested.emit(target_pos)
				fire_timer = 0.0

func _find_closest_target() -> void:
	var closest_node: Node3D = null
	var shortest_distance: float = 99999.0
	
	for target in targets_to_aim:
		if target != null and is_instance_valid(target):
			var distance_to_target = global_position.distance_to(target.global_position)
			if distance_to_target < shortest_distance:
				shortest_distance = distance_to_target
				closest_node = target
				
	if closest_node != current_target:
		current_target = closest_node
		if current_target != null:
			target_acquired.emit(current_target)
