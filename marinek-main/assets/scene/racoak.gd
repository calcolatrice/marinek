extends CharacterBody2D

@onready var racoak = $AnimatedSprite2D      # Sprite del protagonista
@onready var path = $Area2D                # Marker che segue il protagonista (figlio del protagonista)
@onready var marinek = null   # Aiutante: assicurati che il percorso sia corretto!

@onready var ground_check = $Area2D/ground_check  # Raycast che controlla il terreno
@onready var wall_check = $Area2D/wall_check  # Raycast che controlla i muri

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var offset = Vector2(-65, 35)  # Impostiamo l'offset subito a Vector2(65, 35)
var marinek_scene = preload("res://assets/scene/marinek.tscn")  # Sostituisci con il percorso giusto della scena
var marinek_sprite = null

func _ready():
	ground_check.set_collision_mask_value(3, false)
	wall_check.set_collision_mask_value(3, false)
	

	marinek = marinek_scene.instantiate()
	add_child(marinek)
	marinek_sprite = marinek.get_node("AnimatedSprite2D")

	path.position = offset

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		if (direction > 0 and velocity.x < 0) or (direction < 0 and velocity.x > 0):
			velocity.x = 0  
		velocity.x = direction * SPEED  
	else:
		velocity.x = 0  

	# Controllo se il path è bloccato da un muro o se è sospeso
	var is_hitting_wall = wall_check.is_colliding()
	var is_floating = not ground_check.is_colliding()

	if direction > 0:
		racoak.flip_h = false
		if marinek_sprite:
			marinek_sprite.flip_h = false  
		path.position = Vector2(offset.x, offset.y)

	elif direction < 0:
		racoak.flip_h = true
		if marinek_sprite:
			marinek_sprite.flip_h = true  
		path.position = Vector2(-offset.x, offset.y)

	# Se il path è bloccato da un muro o è sospeso, lo posizioniamo sotto il protagonista
	if is_hitting_wall or is_floating:
		path.position = Vector2(0, 35)  # Sposta il path sotto il protagonista

	move_and_slide()  

	# Marinek segue il path
	var target_position = global_position + path.position
	marinek.global_position = marinek.global_position.lerp(target_position, 0.1)
