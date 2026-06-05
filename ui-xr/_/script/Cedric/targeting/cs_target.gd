#@tool
#class_name CSTarget
#extends StaticBody3D
#
### Émis lorsque la cible d'entraînement prend des dégâts.
#signal target_damaged(current_health: int)
### Émis lorsque la vie de la cible atteint zéro.
#signal target_destroyed()
#
#@export var health: int = 100
#@export var auto_reset: bool = true
#
#func take_damage(amount: int) -> void:
	#health -= amount
	#target_damaged.emit(health)
	#
	#if health <= 0:
		#target_destroyed.emit()
		#if auto_reset:
			#health = 100
		#else:
			#queue_free()
