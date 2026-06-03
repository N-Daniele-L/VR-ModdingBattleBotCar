extends Node

## The place for the player to write code to be run when requested.
@export var code_edit:CodeEdit

func _ready() -> void:
	load_text_color_style()

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
		"int": Color("000AAB"),
		"float": Color("000AAB"),
		"bool": Color("000AAB"),
		"String": Color("000AAB"),
		"Array": Color("000AAB"),
		"Dictionary": Color("000AAB"),
		"Vector2": Color("000AAB"),
		"Vector3": Color("000AAB"),
		"Color": Color("000AAB"),
		"Node": Color("000AAB"),
		"Object": Color("000AAB")
	}

	# General token colors
	highlighter.number_color = Color("06DA01")
	highlighter.symbol_color = Color("514EB2")
	highlighter.function_color = Color("000AAB")
	highlighter.member_variable_color = Color("623CD4")
	

	# Regions
	highlighter.add_color_region("\"", "\"", Color("06DA01"), false)
	highlighter.add_color_region("'", "'", Color("06DA01"), false)
	highlighter.add_color_region("#", "", Color("7d7d7d"), true)

	code_edit.syntax_highlighter = highlighter
