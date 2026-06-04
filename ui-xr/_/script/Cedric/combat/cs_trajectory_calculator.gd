@tool
class_name CSTrajectoryCalculator
extends Node

## Émis à chaque frame pour notifier la mise à jour de la position 3D calculée.
signal position_updated(new_position: Vector3)
## Émis lorsque la progression interpolée atteint son terme (1.0).
signal trajectory_finished()

@export var parabola_height: float = 5.0
@export var trajectories: Array[TrajectoryStrategy] = []

var start_position: Vector3 = Vector3.ZERO
var target_position: Vector3 = Vector3.ZERO
var speed: float = 0.0
var progress: float = 0.0
var total_distance: float = 0.0
var is_moving: bool = false
var current_trajectory_index: int = 0 

func start_movement(start_pos: Vector3, target_pos: Vector3, bullet_speed: float, trajectory_type: int) -> void:
	start_position = start_pos
	target_position = target_pos
	speed = bullet_speed
	progress = 0.0
	current_trajectory_index = trajectory_type
	total_distance = start_position.distance_to(target_position)
	
	if total_distance < 0.01:
		is_moving = false
		trajectory_finished.emit()
		return
	is_moving = true

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() or not is_moving:
		return
		
	progress += (speed / total_distance) * delta
	if progress >= 1.0:
		progress = 1.0
		is_moving = false
		
	if current_trajectory_index < trajectories.size():
		var strategy = trajectories[current_trajectory_index]
		if strategy != null:
			var next_pos = strategy.calculate_point(start_position, target_position, progress)
			get_parent().global_position = next_pos
			position_updated.emit(next_pos)
			
	if not is_moving:
		trajectory_finished.emit()
