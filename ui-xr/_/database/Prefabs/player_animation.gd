extends AnimationTree

@onready var animation_tree: AnimationTree = $"."
var attack : bool
var hit : bool

func _process(delta: float) -> void:
	if attack:
		animation_tree["parameters/conditions/armattack"] = false
		animation_tree["parameters/conditions/missileattack"] = false
		attack = false
	if hit:
		animation_tree["parameters/conditions/hit"] = false
		hit = false


func set_walk_animation(iswalking : bool)-> void:
	if iswalking:
		animation_tree["parameters/conditions/notmove"] = false
		animation_tree["parameters/conditions/move"] = true
	else:
		animation_tree["parameters/conditions/notmove"] = true
		animation_tree["parameters/conditions/move"] = false

func set_arm_attack_animation() -> void:
	if attack:
		return
	animation_tree["parameters/conditions/armattack"] = true
	attack = true

func set_missile_attack_animation() -> void:
	if attack:
		return
	animation_tree["parameters/conditions/missileattack"] = true
	attack = true

func set_hit_animation() -> void:
	if hit:
		return
	animation_tree["parameters/conditions/hit"] = true
	hit = true


func set_death_animation() -> void:
	animation_tree["parameters/conditions/death"] = true
