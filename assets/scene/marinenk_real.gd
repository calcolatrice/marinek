extends Area2D

@export var speed : float = 200.0  # Velocità di movimento

func _process(delta):
	# Muove il secondo personaggio verso la target_position
	position = position.move_toward(Communication.target_position, speed * delta)
