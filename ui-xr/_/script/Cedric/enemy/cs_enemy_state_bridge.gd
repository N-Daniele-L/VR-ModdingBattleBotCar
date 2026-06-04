@tool
class_name CSEnemyStateBridge
extends Node

## Émis pour notifier l'UI, le débug ou l'audio du changement d'état d'une entité.
signal global_enemy_state_broadcasted(unit_name: String, state_id: int, state_name: String)

func _on_enemy_state_changed(state_id: int, state_name: String) -> void:
	global_enemy_state_broadcasted.emit(get_parent().name, state_id, state_name)
