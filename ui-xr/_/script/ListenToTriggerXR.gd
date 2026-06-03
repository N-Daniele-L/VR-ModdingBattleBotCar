class_name GodotPlusListenToControllerTrigger
extends Node

signal on_trigger_down()
signal on_trigger_up()
signal on_trigger_changed_state(is_on:bool)

@export var xr_controller:XRController3D 
@export var is_trigger_on:bool
@export var node_name_if_null:String = "RightHandController"

func _ready() -> void:
	if not xr_controller:
		xr_controller=get_tree().root.find_child(node_name_if_null,true,false)

func _process(delta: float) -> void:
	if xr_controller:
		var is_on:=xr_controller.get_float("trigger")>0.1
		var changed:= is_trigger_on!=is_on
		is_trigger_on= is_on
		if changed:
			on_trigger_changed_state.emit(is_on)
			if is_on:
				on_trigger_down.emit()
			else:
				on_trigger_up.emit()
		
