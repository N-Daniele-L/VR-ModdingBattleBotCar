extends Node3D

@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport

func _ready() -> void:
	sprite_3d.texture = sub_viewport.get_texture()
