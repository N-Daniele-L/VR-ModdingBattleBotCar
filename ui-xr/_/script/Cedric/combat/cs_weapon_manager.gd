@tool
class_name CSWeaponManager
extends Node3D

## Émis lorsque l'arme exécute l'action de tir avec succès.
signal weapon_fired()

@export var pool_bullet_type: String = "PlayerProjectile"
@export var bullet_speed: float = 20.0
@export var bullet_damage: int = 5
@export var bullet_lifetime: float = 2.0
@export var fire_rate: float = 0.2
@export var trajectory_type: int = 0
@export var parabola_height: float = 3.0
@export var bullet_color: Color = Color(1.0, 0.5, 0.0, 1.0)
var target_to_aim: Array[Node3D]

var time_since_last_fire: float = 0.0
var can_shoot: bool = true

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	var turret = get_parent() as CSTestTurretController
	if turret != null:
		target_to_aim = turret.targets_to_aim
		turret.shot_requested.connect(handle_shoot_signal)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if not can_shoot:
		time_since_last_fire += delta
		if time_since_last_fire >= fire_rate:
			can_shoot = true
			time_since_last_fire = 0.0
	if can_shoot:
		handle_shoot_signal(target_to_aim[0].global_position)

func handle_shoot_signal(target_position: Vector3) -> void:
	if can_shoot:
		can_shoot = false
		var spawner = get_node_or_null("ProjectileSpawner") as CSProjectileSpawner
		if spawner != null:
			spawner.spawn_projectile(pool_bullet_type, bullet_damage, bullet_lifetime, bullet_speed, trajectory_type, target_position, bullet_color)
			weapon_fired.emit()


func _on_cs_test_turret_shot_requested(target_position: Vector3) -> void:
	pass # Replace with function body.
