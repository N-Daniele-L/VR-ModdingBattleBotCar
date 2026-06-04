class_name RobotFacade
extends Node

signal shoot_requested
signal stop_requested
signal reload_requested
signal reset_all_overrides_requested
signal damage_changed(value: int)
signal range_changed(value: float)
signal fire_rate_changed(value: float)
signal target_mode_changed(mode: String)
signal facade_message(message: String)
signal invalid_value_received(method_name: String, value: Variant)
signal controlled_target_changed(node: Node)

@export var controlled_target: Node
@export var auto_forward_to_target: bool = false

@export_group("Limits")
@export var min_damage: int = 1
@export var max_damage: int = 999
@export var min_range: float = 1.0
@export var max_range: float = 100.0
@export var min_fire_rate: float = 0.1
@export var max_fire_rate: float = 10.0

@export_group("Current Values")
@export var damage: int = 10
@export var range: float = 10.0
@export var fire_rate: float = 1.0
@export var target_mode: String = "nearest"

var allowed_target_modes: Array[String] = [
	"nearest",
	"strongest",
	"weakest",
	"first"
]

func set_controlled_target(node: Node) -> void:
	controlled_target = node
	controlled_target_changed.emit(controlled_target)

func shoot() -> void:
	shoot_requested.emit()
	_forward_method("shoot")
	_send_message("Shoot requested.")

func stop() -> void:
	stop_requested.emit()
	_forward_method("stop")
	_send_message("Stop requested.")

func reload() -> void:
	reload_requested.emit()
	_forward_method("reload")
	_send_message("Reload requested.")

func reset_all_overrides() -> void:
	damage = 10
	range = 10.0
	fire_rate = 1.0
	target_mode = "nearest"

	reset_all_overrides_requested.emit()
	damage_changed.emit(damage)
	range_changed.emit(range)
	fire_rate_changed.emit(fire_rate)
	target_mode_changed.emit(target_mode)

	_forward_method("reset_all_overrides")
	_send_message("All overrides reset.")

func set_damage(value: Variant) -> void:
	if not _is_number(value):
		_reject_value("set_damage", value)
		return

	damage = int(clamp(_to_float(value), float(min_damage), float(max_damage)))
	damage_changed.emit(damage)
	_forward_method_with_value("set_damage", damage)
	_send_message("Damage changed to " + str(damage) + ".")

func set_range(value: Variant) -> void:
	if not _is_number(value):
		_reject_value("set_range", value)
		return

	range = clamp(_to_float(value), min_range, max_range)
	range_changed.emit(range)
	_forward_method_with_value("set_range", range)
	_send_message("Range changed to " + str(range) + ".")

func set_fire_rate(value: Variant) -> void:
	if not _is_number(value):
		_reject_value("set_fire_rate", value)
		return

	fire_rate = clamp(_to_float(value), min_fire_rate, max_fire_rate)
	fire_rate_changed.emit(fire_rate)
	_forward_method_with_value("set_fire_rate", fire_rate)
	_send_message("Fire rate changed to " + str(fire_rate) + ".")

func set_target_mode(mode: String) -> void:
	var clean_mode := mode.strip_edges().to_lower()

	if not allowed_target_modes.has(clean_mode):
		_reject_value("set_target_mode", mode)
		return

	target_mode = clean_mode
	target_mode_changed.emit(target_mode)
	_forward_method_with_value("set_target_mode", target_mode)
	_send_message("Target mode changed to " + target_mode + ".")

func get_damage() -> int:
	return damage

func get_range() -> float:
	return range

func get_fire_rate() -> float:
	return fire_rate

func get_target_mode() -> String:
	return target_mode

func _forward_method(method_name: String) -> void:
	if not auto_forward_to_target:
		return

	if controlled_target and controlled_target.has_method(method_name):
		controlled_target.call(method_name)

func _forward_method_with_value(method_name: String, value: Variant) -> void:
	if not auto_forward_to_target:
		return

	if controlled_target and controlled_target.has_method(method_name):
		controlled_target.call(method_name, value)

func _is_number(value: Variant) -> bool:
	if typeof(value) == TYPE_INT:
		return true

	if typeof(value) == TYPE_FLOAT:
		return true

	if typeof(value) == TYPE_STRING and str(value).is_valid_float():
		return true

	return false

func _to_float(value: Variant) -> float:
	return str(value).to_float()

func _reject_value(method_name: String, value: Variant) -> void:
	invalid_value_received.emit(method_name, value)
	_send_message("Invalid value for " + method_name + ": " + str(value))

func _send_message(message: String) -> void:
	print(message)
	facade_message.emit(message)
