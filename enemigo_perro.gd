extends CharacterBody2D

# --- Variables de Configuración ---
const GRAVITY = 980.0
const ATTACK_DISTANCE = 50.0 
var health = 3 # Vida inicial del perro
var target_body = null # Referencia al cuerpo del gato
# Estados del enemigo (usaremos un enum simple)
enum State {IDLE, ATTACKING, DYING} # Añadido estado DYING
var current_state = State.IDLE # El perro empieza quieto

# --- Referencias a Nodos (@onready) ---
@onready var sprite_visual = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var area_detector = $Area2D
@onready var attack_timer = $AttackTimer # DEBE estar conectado a la señal 'timeout'

# --- Función de Inicialización ---
func _ready():
	animation_player.play("descanso")

# --- Función de Procesamiento de Física ---
func _physics_process(delta: float) -> void:
	# 1. Aplicar Gravedad
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		
	# 2. Lógica de Estado (Animación)
	if current_state == State.IDLE:
		animation_player.play("descanso")
	elif current_state == State.ATTACKING:
		# Reproduce la animación de ataque/ladrido continuo
		animation_player.play("ataque") 
	elif current_state == State.DYING:
		# Si está muriendo, no hacemos nada más que mover (gravedad)
		pass

	# 3. Mover el cuerpo (solo para aplicar gravedad y deslizar)
	move_and_slide()
	
	# Opcional: Voltear hacia el gato si está en rango
	if target_body != null:
		look_at_target(target_body.global_position.x)


# --- Función para Voltear (Opcional: hacer que mire al gato) ---
func look_at_target(target_x):
	var my_x = global_position.x
	if target_x > my_x:
		sprite_visual.flip_h = true
	else:
		sprite_visual.flip_h = false

# --- Lógica de Detección (CORREGIDA: Solo cambia estado y activa Timer) ---
func _on_area_2d_body_entered(body):
	# NOTA: En Godot, el nombre del nodo principal del Gato debe ser 'Cat' para que esto funcione.
	if body.name == "Cat":
		current_state = State.ATTACKING
		target_body = body # Guardamos la referencia al gato
		attack_timer.start() # Empezar a hacer daño periódico

func _on_area_2d_body_exited(body):
	if body.name == "Cat":
		current_state = State.IDLE
		target_body = null
		attack_timer.stop() # Dejar de hacer daño
		
# --- Función de Daño Periódico (CORREGIDA: Aplica daño y fuerza la animación) ---
func _on_attack_timer_timeout():
	if current_state == State.ATTACKING and target_body != null:
		# 1. El perro ladra (visual/sonido)
		animation_player.play("ataque") 
		# 2. Le quita vida al gato (Daño)
		if target_body.has_method("take_damage"):
			target_body.take_damage(1) # Daño infligido por el perro

# --- Función para recibir daño del gato ---
func take_damage(amount):
	if current_state == State.DYING: return

	health -= amount
	
	if health <= 0:
		die()
	else:
		# Reacción: ASUME que tienes una animación llamada "Hurt"
		if animation_player.has_animation("Hurt"):
			animation_player.play("Hurt")
		
func die():
	current_state = State.DYING
	
	# Si tienes animación de muerte, úsala
	# if animation_player.has_animation("Muerte"):
	# 	animation_player.play("Muerte")
	# 	await animation_player.animation_finished
	
	queue_free()
