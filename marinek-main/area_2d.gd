extends Area2D

enum State { IDLE, MOVING, ATTACKING1, ATTACKING2, ATTACKING3, STUNNED }
var current_state = State.IDLE  

const SPEED = 100.0
const ATTACK_COOLDOWN = 2.0
const STUN_DURATION = 2.0

var velocity = Vector2.ZERO
var player = null
var attack_timer = ATTACK_COOLDOWN
var stun_timer = 0.0

func _ready() -> void:
	player = get_node("/root/Gamestate/CharacterBody2D")
	if player == null:
		print("Errore: Nessun player trovato!")
	else:
		current_state = State.MOVING  # Avvia il movimento

func _physics_process(delta: float) -> void:
	velocity.y = 0
	print("Stato attuale:", current_state)  # Debug

	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO  

		State.MOVING:
			move_towards_player(delta)

		State.ATTACKING1, State.ATTACKING2, State.ATTACKING3:
			velocity = Vector2.ZERO  # Si ferma per attaccare

		State.STUNNED:
			stun_timer -= delta
			if stun_timer <= 0:
				current_state = State.MOVING  

	# Muove il boss solo se non è stordito o attaccando
	if current_state in [State.MOVING]:
		position += velocity * delta  

	# Timer per gli attacchi
	attack_timer -= delta
	if attack_timer <= 0 and current_state == State.MOVING:
		start_attack()

func move_towards_player(delta: float):
	if player:
		var direction = (player.position - position).normalized()
		velocity = direction * SPEED  # Aggiorna la velocità
	else:
		velocity = Vector2.ZERO

func start_attack():
	attack_timer = ATTACK_COOLDOWN  
	var attack_choice = randi() % 3  

	match attack_choice:
		0:
			current_state = State.ATTACKING1
			attack1()
		1:
			current_state = State.ATTACKING2
			attack2()
		2:
			current_state = State.ATTACKING3
			attack3()

func attack1():
	print("Attacco 1! (Dash fluido)")

	if player:
		var direction = (player.position - position).normalized()
		var dash_speed = 200  # Velocità dello scatto
		var dash_duration = 1.0  # Durata dello scatto

		var target_position = position + (direction * dash_speed * dash_duration)

		# Tween per animare lo scatto
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", target_position, dash_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

		# Aspetta la fine del dash prima di tornare in MOVING
		await get_tree().create_timer(dash_duration + 0.2).timeout  
	
	current_state = State.MOVING  


func attack2():
	print("Attacco 2!")
	await get_tree().create_timer(0.7).timeout  
	current_state = State.MOVING  

func attack3():
	print("Attacco 3!")
	await get_tree().create_timer(1.0).timeout  
	current_state = State.MOVING  

func start_stunned():
	print("Boss è stordito!")
	current_state = State.STUNNED
	stun_timer = STUN_DURATION
	velocity = Vector2.ZERO  
