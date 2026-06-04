class_name ParabolaTrajectory
extends TrajectoryStrategy

@export var parabola_height: float = 5.0

func calculate_point(start: Vector3, end: Vector3, progress: float) -> Vector3:
	var base_pos = start.lerp(end, progress)
	var height_offset = 4.0 * parabola_height * progress * (1.0 - progress)
	base_pos.y += height_offset
	return base_pos
