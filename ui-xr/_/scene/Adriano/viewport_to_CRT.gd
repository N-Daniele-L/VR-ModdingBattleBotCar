extends MeshInstance3D


@export var viewport : SubViewport
var material : StandardMaterial3D
var image : Image
var texture


func _ready() -> void:
	material = get_active_material(0).duplicate()
	set_surface_override_material(0,material)
	image = viewport.get_texture().get_image()
	texture = ImageTexture.create_from_image(image)
	
func _physics_process(delta: float) -> void:
	material.albedo_texture = texture
	image = viewport.get_texture().get_image()
	texture.update(image)
