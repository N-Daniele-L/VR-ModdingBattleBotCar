class_name NCARPoolSystem
extends Node3D

@export var object_to_instantiate : PackedScene
@export var number_of_object : int = 10
@export var name_pooled : String = "PooledObject"

func _ready() -> void:
	
	for i in number_of_object:
		var object :Node3D = object_to_instantiate.instantiate()
		self.add_child(object)
		object.name = name_pooled + " " + str(i)
		object.visible = false

func get_object_from_pool() -> Node3D:
	for child in self.get_children():
		if child.visible == false:
			child.visible = true
			return child
	
	var object :Node3D = object_to_instantiate.instantiate()
	var count : int = self.get_child_count(false)
	self.add_child(object)
	object.name = name_pooled + " " + str(count +1)
	return object
