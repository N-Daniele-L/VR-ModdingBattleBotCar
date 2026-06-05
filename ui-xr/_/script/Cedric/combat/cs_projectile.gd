@tool
class_name CSProjectile
extends Area3D

## Émis lorsque le temps de vie maximum du projectile est écoulé.
signal projectile_expired(instance: CSProjectile)
## Émis lorsque le projectile entre en collision avec une cible valide.
signal projectile_impacted(instance: CSProjectile, target: Node3D)

var current_damage: int = 0
var max_lifetime: float = 3.0
var alive_time: float = 0.0

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	var collision_node = get_node_or_null("CollisionDamage") as CSCollisionDamage
	if collision_node != null:
		collision_node.impact_emitted.connect(_on_collision_impact)

func initialize_projectile(damage: int, lifetime: float, speed: float, trajectory_type: int, target_position: Vector3, color: Color) -> void:
	current_damage = damage
	max_lifetime = lifetime
	alive_time = 0.0
	
	var trajectory_node = get_node_or_null("TrajectoryCalculator") as CSTrajectoryCalculator
	if trajectory_node != null:
		trajectory_node.start_movement(global_position, target_position, speed, trajectory_type)
		
	var visuals_node = get_node_or_null("VisualEffectsManager") as CSVisualEffectsManager
	if visuals_node != null:
		visuals_node.apply_visual_settings(color)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	alive_time += delta
	if alive_time >= max_lifetime:
		projectile_expired.emit(self)
		self.visible = false

func _on_collision_impact(target: Node3D) -> void:
	if target.is_in_group("PlayerTargets"):
		return
	if target.is_in_group("enemy"):
		projectile_impacted.emit(self, target)
		self.visible = false
