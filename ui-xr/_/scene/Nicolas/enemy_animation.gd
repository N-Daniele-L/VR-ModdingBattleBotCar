class_name EnemyAnimation
extends AnimationTree

@onready var animation_tree: AnimationTree = $"."
var attack : bool


func _process(delta: float) -> void:
	if attack:
		attack = false
		animation_tree["parameters/conditions/attack"] = false

func set_walk_animation(iswalking : bool)-> void:
	if iswalking:
		animation_tree["parameters/conditions/notmove"] = false
		animation_tree["parameters/conditions/move"] = true
	else:
		animation_tree["parameters/conditions/notmove"] = true
		animation_tree["parameters/conditions/move"] = false

func set_attack_animation() -> void:
	if attack:
		return
	animation_tree["parameters/conditions/attack"] = true
	attack = true
	

func set_death_animation() -> void:
	animation_tree["parameters/conditions/death"] = true
