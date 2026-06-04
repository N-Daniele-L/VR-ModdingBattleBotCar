extends Control

@onready var rich_text_label: RichTextLabel = $AspectRatioContainer/RichTextLabel


func change_text(text : String)-> void:
	if text == "":
		return
	rich_text_label.text = text
