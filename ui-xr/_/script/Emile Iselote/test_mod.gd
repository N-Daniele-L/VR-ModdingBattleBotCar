class_name TestMod
extends Node3D

@export var label: Label3D
@export var mesh: MeshInstance3D

var damage: int = 10
var _range: float = 10.0
var fire_rate: float = 1.0

func shoot() -> void:
	print("Turret shoots")
	if label:
		label.text = "Shoot"

func set_damage(value: int) -> void:
	damage = value
	print("Damage:", damage)
	if label:
		label.text = "Damage: " + str(damage)

func set_range(value: float) -> void:
	_range = value
	print("Range:", range)
	if label:
		label.text = "Range: " + str(range)

func set_fire_rate(value: float) -> void:
	fire_rate = value
	print("Fire rate:", fire_rate)
	if label:
		label.text = "Fire Rate: " + str(fire_rate)

func reset_all_overrides() -> void:
	damage = 10
	_range = 10.0
	fire_rate = 1.0
	print("Turret reset")
	if label:
		label.text = "Reset"
