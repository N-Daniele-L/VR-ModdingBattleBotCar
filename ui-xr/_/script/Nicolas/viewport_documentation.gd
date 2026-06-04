extends Node3D

@onready var quad: MeshInstance3D = $size/Quad
@onready var sub_viewport: SubViewport = $size/SubViewport

signal send_text_to_control(text : String)


func _ready() -> void:
	var material :StandardMaterial3D = quad.get_active_material(0)
	material.albedo_texture = sub_viewport.get_texture()
	
func emit_text_to_control(text : String) -> void:
	send_text_to_control.emit (text)
