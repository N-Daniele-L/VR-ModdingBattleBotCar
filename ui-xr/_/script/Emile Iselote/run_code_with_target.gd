class_name RunCodeWithTarget
extends Control

signal target_changed(target_node: Node)
signal code_reloaded(code: String)
signal code_stopped
signal code_node_created(node: Node)
signal code_node_destroyed
signal code_load_failed(code: String)
signal url_detected(url: String)
signal reset_all_overrides_requested

@export var code_edit: CodeEdit
@export var target_node: Node
@export var where_to_run_code: Node
@export var method_to_notify_new_target: String = "_on_received_target"
@export var unique_code_file_name: String = "code_edit"
@export var create_node_as_node_3d: bool = false
@export var use_default_color_style: bool = true

@export_group("Debug")
@export var created_node_holding_code: Node

var default_code: String = """extends Node

var target: Node = 10

func _on_received_target(new_target: Node) -> void:
	target = new_target
	if target and target.has_method("shoot"):
		target.shoot()
"""

func _ready() -> void:
	if code_edit and code_edit.text.strip_edges() == "":
		code_edit.text = default_code

	if use_default_color_style and code_edit:
		load_text_color_style()

func _on_run_button_pressed() -> void:
	reload_code_from_code_edit()

func _on_stop_button_pressed() -> void:
	unload_current_code()

func _on_reset_code_button_pressed() -> void:
	reset_code_edit()

func _on_reset_all_overrides_button_pressed() -> void:
	reset_all_overrides_requested.emit()

	if target_node and target_node.has_method("reset_all_overrides"):
		target_node.call("reset_all_overrides")

func _on_plus_size_button_pressed() -> void:
	increase_text_size()

func _on_less_size_button_pressed() -> void:
	reduce_text_size()

func set_target_node(node: Node) -> void:
	target_node = node
	target_changed.emit(target_node)
	notify_created_node_about_target()

func set_code_in_code_edit_without_reload(text: String) -> void:
	if code_edit:
		code_edit.text = text

func set_code_in_code_edit_and_reload(text: String) -> void:
	if code_edit:
		code_edit.text = text
		reload_code_from_code_edit()

func reset_code_edit() -> void:
	if code_edit:
		code_edit.text = default_code

func reload_code_from_code_edit() -> void:
	if not code_edit:
		code_load_failed.emit("")
		return

	var code: String = code_edit.text
	code_reloaded.emit(code)
	load_and_run_text_as_godot_script(code)

func unload_current_code() -> void:
	if created_node_holding_code:
		created_node_holding_code.queue_free()
		created_node_holding_code = null

	code_stopped.emit()
	code_node_destroyed.emit()

func is_url(text: String) -> bool:
	var clean_text := text.strip_edges()
	return clean_text.begins_with("http://") or clean_text.begins_with("https://")

func load_and_run_text_as_godot_script(code: String) -> void:
	if is_url(code):
		url_detected.emit(code)
		return

	if not code.contains("extends "):
		code = "extends Node\n\n" + code

	unload_current_code()

	var script_path := "user://" + unique_code_file_name
	var file := FileAccess.open(script_path, FileAccess.WRITE)

	if not file:
		code_load_failed.emit(code)
		return

	file.store_string(code)
	file.close()

	var script := ResourceLoader.load(
		script_path,
		"GDScript",
		ResourceLoader.CACHE_MODE_IGNORE
	)

	if script == null or not script is GDScript:
		code_load_failed.emit(code)
		return

	var node: Node = Node3D.new() if create_node_as_node_3d else Node.new()
	node.set_script(script)
	node.set_process(true)
	node.set_physics_process(true)

	created_node_holding_code = node
	prepare_created_node_with_target()

	if where_to_run_code:
		where_to_run_code.add_child(node)
	else:
		add_child(node)

	code_node_created.emit(node)

func prepare_created_node_with_target() -> void:
	if not created_node_holding_code:
		return

	if target_node and has_property_of_node(created_node_holding_code, "target"):
		created_node_holding_code.set("target", target_node)

	notify_created_node_about_target()

func notify_created_node_about_target() -> void:
	if created_node_holding_code and target_node and created_node_holding_code.has_method(method_to_notify_new_target):
		created_node_holding_code.call(method_to_notify_new_target, target_node)

func has_code_running() -> bool:
	return created_node_holding_code != null

func has_target_node() -> bool:
	return target_node != null

func has_target_node_and_code_running() -> bool:
	return has_target_node() and has_code_running()

func get_holding_code_node() -> Node:
	return created_node_holding_code

func get_target_node() -> Node:
	return target_node

static func has_property_of_node(node: Node, property_name: String) -> bool:
	for property in node.get_property_list():
		if property.name == property_name:
			return true

	return false

func increase_text_size() -> void:
	if not code_edit:
		return

	code_edit.add_theme_font_size_override(
		"font_size",
		code_edit.get_theme_font_size("font_size") + 1
	)

func reduce_text_size() -> void:
	if not code_edit:
		return

	code_edit.add_theme_font_size_override(
		"font_size",
		code_edit.get_theme_font_size("font_size") - 1
	)

func load_text_color_style():
	var highlighter := CodeHighlighter.new()

	# Keywords
	highlighter.keyword_colors = {
		"if": Color("06DA01"),
		"elif": Color("06DA01"),
		"else": Color("06DA01"),
		"for": Color("06DA01"),
		"while": Color("06DA01"),
		"match": Color("06DA01"),
		"break": Color("06DA01"),
		"continue": Color("06DA01"),
		"pass": Color("06DA01"),
		"return": Color("06DA01"),
		"class": Color("06DA01"),
		"class_name": Color("06DA01"),
		"extends": Color("06DA01"),
		"func": Color("06DA01"),
		"static": Color("06DA01"),
		"const": Color("06DA01"),
		"var": Color("06DA01"),
		"enum": Color("06DA01"),
		"signal": Color("06DA01"),
		"await": Color("06DA01"),
		"yield": Color("06DA01"),
		"assert": Color("06DA01")
	}

	# Built-in types
	highlighter.member_keyword_colors = {
		"int": Color("2FFFF5"),
		"float": Color("2FFFF5"),
		"bool": Color("2FFFF5"),
		"String": Color("2FFFF5"),
		"Array": Color("2FFFF5"),
		"Dictionary": Color("2FFFF5"),
		"Vector2": Color("2FFFF5"),
		"Vector3": Color("2FFFF5"),
		"Color": Color("2FFFF5"),
		"Node": Color("2FFFF5"),
		"Object": Color("2FFFF5")
	}

	# General token colors
	highlighter.number_color = Color("06DA01")
	highlighter.symbol_color = Color("514EB2")
	highlighter.function_color = Color("ce0000ff")
	highlighter.member_variable_color = Color("623CD4")
	

	# Regions
	highlighter.add_color_region("\"", "\"", Color("06DA01"), false)
	highlighter.add_color_region("'", "'", Color("06DA01"), false)
	highlighter.add_color_region("#", "", Color("7d7d7d"), true)

	code_edit.syntax_highlighter = highlighter


func run_command() -> void:
	pass # Replace with function body.
