class_name NCAREnemyMovement
extends CharacterBody3D

@export var speed : float = 5
@export var enemy_anim : EnemyAnimation
@export var cooldown_attack : float = 4
var chrono : float




func _physics_process(delta: float) -> void:
	var target : Node3D = get_tree().get_first_node_in_group("player")
	if not visible:
		return
	var direction = global_position.direction_to(target.global_position)
	direction.y = 0
	velocity = direction * speed
	
	if global_position.distance_to(target.global_position) <= 5:
		velocity = Vector3.ZERO
		enemy_anim.set_walk_animation(false)
		chrono -=delta
		if chrono <= 0:
			_attack()
			chrono = cooldown_attack
		
	else:
		enemy_anim.set_walk_animation(true)
	look_at(target.global_position, Vector3.UP)
	
	move_and_slide()
	
func _attack()->void:
	enemy_anim.set_attack_animation()
