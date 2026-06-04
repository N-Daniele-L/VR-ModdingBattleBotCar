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
		"pass": Color("ff7fc5ff"),
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
		"int": Color("4179feff"),
		"float": Color("4179feff"),
		"bool": Color("4179feff"),
		"String": Color("4179feff"),
		"Array": Color("4179feff"),
		"Dictionary": Color("4179feff"),
		"Vector2": Color("4179feff"),
		"Vector3": Color("4179feff"),
		"Color": Color("4179feff"),
		"Node": Color("4179feff"),
		"Object": Color("4179feff")
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
