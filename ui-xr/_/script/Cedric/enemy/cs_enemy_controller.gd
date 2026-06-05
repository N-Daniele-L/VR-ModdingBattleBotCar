#@tool
class_name CSEnemyController
extends CharacterBody3D

## Émis lorsque le cycle de vie de l'ennemi se termine définitivement (Dead).
signal enemy_lifecycle_ended(instance: Node3D)
## Émis lors de chaque changement interne d'état comportemental.
signal state_changed(new_state: int, state_name: String)

## Émis lorsque la cible d'entraînement prend des dégâts.
signal target_damaged(current_health: int)
## Émis lorsque la vie de la cible atteint zéro.
signal target_destroyed()

@export var health: int = 5
@export var auto_reset: bool = true

enum EnemyState { INITIALIZING, SEARCHING_TARGET, MOVING_TO_TARGET, ATTACKING_TARGET, DYING, DEAD }

var current_state: EnemyState = EnemyState.INITIALIZING
var target_node: Node3D = null
var player_pos: Vector3

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	var bridge = get_node_or_null("EnemyStateBridge") as CSEnemyStateBridge
	if bridge != null:
		pass
		state_changed.connect(bridge._on_enemy_state_changed)

func activate_enemy(spawn_position: Vector3) -> void:
	global_position = spawn_position
	target_node = null
	velocity = Vector3.ZERO
	change_state(EnemyState.INITIALIZING)
	change_state(EnemyState.SEARCHING_TARGET)

func change_state(new_state: EnemyState) -> void:
	current_state = new_state
	var state_string = EnemyState.keys()[new_state]
	state_changed.emit(new_state, state_string)

func _physics_process(delta: float) -> void:
	
	if Engine.is_editor_hint() or current_state == EnemyState.DYING or current_state == EnemyState.DEAD:
		return
		
	var movement_comp = get_node_or_null("EnemyMovement") as CSEnemyMovement
	var attack_comp = get_node_or_null("EnemyAttack") as CSEnemyAttack
	if movement_comp == null or attack_comp == null:
		return
		
	match current_state:
		EnemyState.SEARCHING_TARGET:
			target_node = movement_comp.find_closest_player_target()
			if target_node != null:
				change_state(EnemyState.MOVING_TO_TARGET)
				
		EnemyState.MOVING_TO_TARGET:
			if not is_instance_valid(target_node):
				change_state(EnemyState.SEARCHING_TARGET)
				return
			if attack_comp.is_target_in_range(global_position, target_node.global_position):
				velocity = Vector3.ZERO
				change_state(EnemyState.ATTACKING_TARGET)
			else:
				movement_comp.execute_movement(self, target_node.global_position, delta)
				
		EnemyState.ATTACKING_TARGET:
			if not is_instance_valid(target_node):
				change_state(EnemyState.SEARCHING_TARGET)
				return
			if not attack_comp.is_target_in_range(global_position, target_node.global_position):
				change_state(EnemyState.MOVING_TO_TARGET)
			else:
				look_at(Vector3(target_node.global_position.x, global_position.y, target_node.global_position.z), Vector3.UP)
				attack_comp.process_combat_loop(target_node.global_position, delta)

func take_damage(body: Node3D) -> void:
	if body.is_in_group("projectile"):
		var character_parent: Node3D = self.get_parent()
		character_parent.visible = false
		change_state(EnemyState.DEAD)
		enemy_lifecycle_ended.emit(self.get_parent_node_3d())
