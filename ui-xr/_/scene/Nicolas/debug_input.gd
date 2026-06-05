extends Node3D

@onready var ncar_spawner_enemy: NCARSpawner = $"NCARSpawner-Enemy"


func on_button_press(name : String)->void:
	print(name)
	if name == "ax_button":
		ncar_spawner_enemy.set_spawner(true)
	if name == "by_button":
		ncar_spawner_enemy.set_spawner(false)
