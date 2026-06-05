class_name PlayerRobot
extends Node3D

@export var player_anim : PlayerAnimation
@export_range(3,10) var attack_cooldown : float = 3

var attack_timer : float
var isattacking : bool

func _process(delta: float) -> void:
	if isattacking:
		attack_timer -= delta
		if attack_timer <=0:
			isattacking = false

func shoot()->void:
	print("try to attack")
	if isattacking:
		return 
	player_anim.set_arm_attack_animation()
	isattacking = true
	attack_timer = attack_cooldown
