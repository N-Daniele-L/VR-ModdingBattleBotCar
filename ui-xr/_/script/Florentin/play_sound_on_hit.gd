extends "res://addons/godot-xr-tools/objects/pickable.gd"

@onready var metal_sound: AudioStreamPlayer3D = $AudioStreamPlayer3D_hit_metal
@onready var floor_sound: AudioStreamPlayer3D = $AudioStreamPlayer3D_hit_floor
@onready var wood_sound: AudioStreamPlayer3D = $AudioStreamPlayer3D_hit_wood
@onready var plastic_sound: AudioStreamPlayer3D = $AudioStreamPlayer3D_hit_plastic

@export var cooldown: float = 0.2
var can_play_sound: bool = true


func _ready() -> void:
	super._ready()
	body_entered.connect(_on_body_entered)
	

func _on_body_entered(body: Node) -> void:
	if not can_play_sound:
		return

	if body.is_in_group("hit_metal"):
		metal_sound.play()
	elif body.is_in_group("hit_floor"):
		floor_sound.play()
	elif body.is_in_group("hit_wood"):
		wood_sound.play()
	elif body.is_in_group("hit_plastic"):
		plastic_sound.play()
	else:
		return

	can_play_sound = false
	await get_tree().create_timer(cooldown).timeout
	can_play_sound = true
