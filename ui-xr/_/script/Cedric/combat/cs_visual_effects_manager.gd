@tool
class_name CSVisualEffectsManager
extends Node3D

@export var mesh_variants: Array[Mesh] = []
@export var material_variants: Array[Material] = []

func _ready() -> void:
	if is_node_ready() and Engine.is_editor_hint():
		apply_visual_settings(Color.WHITE)

func apply_visual_settings(target_color: Color) -> void:
	if is_node_ready():
		var my_light = get_node_or_null("GlowLight") as OmniLight3D
		if my_light != null:
			my_light.light_color = target_color
			
		var my_mesh = get_node_or_null("VisualMesh") as MeshInstance3D
		if my_mesh != null:
			var base_material = my_mesh.material_override as StandardMaterial3D
			if base_material == null:
				base_material = StandardMaterial3D.new()
			base_material.albedo_color = target_color
			base_material.emission_enabled = true
			base_material.emission = target_color
			my_mesh.material_override = base_material
			
		var my_particles = get_node_or_null("TrailParticles") as GPUParticles3D
		if my_particles != null:
			var process_mat = my_particles.process_material as ParticleProcessMaterial
			if process_mat != null:
				process_mat.color = target_color
