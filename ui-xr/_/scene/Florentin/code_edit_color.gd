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
		"pass": Color("ff6600ff"),
		"return": Color("06DA01"),
		"class": Color("06DA01"),
		"class_name": Color("06DA01"),
		"export": Color("06DA01"),
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
		"int": Color("41fffeff"),
		"float": Color("41fffeff"),
		"bool": Color("41fffeff"),
		"String": Color("41fffeff"),
		"Array": Color("41fffeff"),
		"Dictionary": Color("41fffeff"),
		"Vector2": Color("41fffeff"),
		"Vector3": Color("41fffeff"),
		"Color": Color("41fffeff"),
		"Node": Color("41fffeff"),
		"Object": Color("41fffeff")
	}

	# General token colors
	highlighter.number_color = Color("ffffffff")
	highlighter.symbol_color = Color("ffffff")
	highlighter.function_color = Color("ff523cff")
	highlighter.member_variable_color = Color("ffffffff")
	

	# Regions
	highlighter.add_color_region("\"", "\"", Color("7d7d7d"), false)
	highlighter.add_color_region("'", "'", Color("7d7d7d"), false)
	highlighter.add_color_region("#", "", Color("7d7d7d"), true)

	code_edit.syntax_highlighter = highlighter
