@tool
class_name CSPoolManager
extends Node

signal object_requested(type: String)
signal object_returned(type: String, instance: Node)

@export var scene_templates: Dictionary = {
	"BasicEnemy": null,
	"EnemyProjectile": null,
	"PlayerProjectile": null
}

var _pools: Dictionary = {}

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	for key in scene_templates.keys():
		_pools[key] = []

func get_from_pool(pool_name: String) -> Node3D:
	if not scene_templates.has(pool_name):
		return null
		
	if not _pools.has(pool_name):
		_pools[pool_name] = []
		
	var pool_array = _pools[pool_name] as Array
	
	while pool_array.size() > 0:
		var instance = pool_array.pop_back() as Node
		if is_instance_valid(instance):
			instance.set_process(true)
			instance.set_physics_process(true)
			if instance is Node3D:
				instance.visible = true
			instance.set_meta("pool_name", pool_name)
			object_requested.emit(pool_name)
			return instance
			
	var template_scene = scene_templates[pool_name] as PackedScene
	if template_scene == null:
		return null
		
	var new_instance = template_scene.instantiate()
	new_instance.set_meta("pool_name", pool_name)
	object_requested.emit(pool_name)
	return new_instance

func return_to_pool(instance: Node3D) -> void:
	if instance == null or not is_instance_valid(instance):
		return
		
	if not instance.has_meta("pool_name"):
		instance.queue_free()
		return
		
	var pool_name = instance.get_meta("pool_name") as String
	if not _pools.has(pool_name):
		_pools[pool_name] = []
		
	instance.set_process(false)
	instance.set_physics_process(false)
	if instance is Node3D:
		instance.visible = false
		
	if instance.get_parent() != null:
		instance.get_parent().remove_child(instance)
		
	_pools[pool_name].append(instance)
	object_returned.emit(pool_name, instance)
