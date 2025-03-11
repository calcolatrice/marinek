extends CharacterBody2D
@onready var racoakchet = $AnimatedSprite2D
@onready var marinek = $"../marinek"
@onready var target = $left_arrow
@onready var right_area = $right_area
@onready var left_area = $left_area

@export var second_character : Node2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const M_SPEED = 300
const M_JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if direction == 1:
		Communication.target_position = left_area.position
		racoakchet.flip_h = false
	elif direction == -1:
		Communication.target_position = right_area.position
		racoakchet.flip_h = true

	move_and_slide()

func _process(delta: float) -> void:
	pass
	
		
	
	
	
