@tool
class_name CSCollisionDamage
extends Node

## Émis lorsqu'une collision physique valide est enregistrée avec un autre corps 3D.
signal impact_emitted(target: Node3D)
signal touched_enemy()

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	var my_parent = get_parent() as Area3D
	if my_parent != null:
		my_parent.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	impact_emitted.emit(body)
	touched_enemy.emit()
