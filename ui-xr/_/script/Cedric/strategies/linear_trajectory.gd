class_name LinearTrajectory
extends TrajectoryStrategy

func calculate_point(start: Vector3, end: Vector3, progress: float) -> Vector3:
	return start.lerp(end, progress)
