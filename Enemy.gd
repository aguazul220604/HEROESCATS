extends CharacterBody2D

# Variables de Vida
var max_health: int = 9
var current_health: int = 9
var is_hurt: bool = false 

# NUEVAS VARIABLES DE ESTADO PARA REPRESALIA
var is_active: bool = false
var attack_sequence: int = 1

# 💥 CORRECCIÓN CRÍTICA: La ruta debe tener la 'V' y la 'S' mayúsculas
const VICTORY_SCENE_RESOURCE = preload("res://victory_screen.tscn") 

# --- REFERENCIAS DE AUDIO ---
# Usamos un solo archivo para: Ataque, Pasos y Recibir Daño.
# Nota: La ruta asume que 'attack.mp3' está en 'res://sound/'
const SONIDO_PUMA = preload("res://level_4/sound/Roar.mp3") 
@onready var sound_player = $PumaSoundEffects # Asumimos que renombraste el nodo a PumaSoundEffects
# -----------------------------

# Referencias
@onready var animacion_enemy = $AnimationPlayer_mapungo
@onready var health_bar = $HealthBarContainer/HealthBar
@onready var attack_timer = $AttackTimer
@onready var enemy_hitbox = $EnemyHitbox

func _ready():
	# 1. Configuración inicial
	add_to_group("Enemy")
	health_bar.max_value = max_health
	update_health_bar()
	
	if enemy_hitbox:
		enemy_hitbox.monitoring = false
	
	# 2. Iniciar la animación de reposo
	if animacion_enemy:
		animacion_enemy.play("reposo")

# Función para actualizar la barra visualmente
func update_health_bar():
	health_bar.value = current_health
	
	if current_health >= max_health or current_health <= 0:
		health_bar.visible = false
	else:
		health_bar.visible = true

# 🚶 LÓGICA DE MOVIMIENTO / PASOS (Integración de Sonido)
func _physics_process(delta):
	# Si el enemigo está en movimiento y no atacando/dañado, reproducimos el sonido.
	# Esta es una lógica simple de "pasos" que se repite si no hay otro sonido.
	var esta_moviendose = velocity.x != 0
	
	if is_active and not is_hurt and esta_moviendose:
		# Si no está sonando nada, iniciamos el sonido de pasos (usando SONIDO_PUMA)
		if not sound_player.is_playing():
			sound_player.stream = SONIDO_PUMA
			sound_player.play()
	
	# Detener sonido si se detiene, está dañado o va a atacar.
	elif sound_player.is_playing():
		sound_player.stop()

# Función llamada por el ataque del gato
func take_damage(damage: int):
	if is_hurt or current_health <= 0:
		return
		
	is_hurt = true
	current_health -= damage
	update_health_bar()

	# 🔊 SONIDO AL RECIBIR DAÑO
	sound_player.stream = SONIDO_PUMA
	sound_player.play()
	
	# >>> LÓGICA DE ACTIVACIÓN / REINICIO DEL TEMPORIZADOR <<<
	if not is_active:
		is_active = true
		attack_timer.start()
	else:
		attack_timer.start() 
	# ---------------------------------------------------------------------------------
	
	animacion_enemy.play("debil")
	
	# Espera fija (0.4s) para animación de daño
	await get_tree().create_timer(0.4).timeout
	
	is_hurt = false

	if current_health <= 0:
		die()
	else:
		animacion_enemy.play("reposo")

# ----------------------------------------------------------------
# LÓGICA DE MUERTE E INSTANCIACIÓN DE VICTORIA
# ----------------------------------------------------------------
func die():
	# 1. Detener el combate
	is_active = false
	attack_timer.stop()
	set_physics_process(false) 
	
	# 2. Reproducir animación de muerte
	animacion_enemy.play("debil")
	
	# Esperar 1.0 segundo para ver la animación
	await get_tree().create_timer(1.0).timeout
	
	# 3. Instanciar y añadir la pantalla de victoria
	var victory_screen_instance = VICTORY_SCENE_RESOURCE.instantiate()
	
	# Añadir la UI de victoria a la raíz del juego para que se muestre sobre el nivel
	get_tree().get_root().add_child(victory_screen_instance)
	
	# 4. Eliminar el enemigo del nivel
	queue_free()
# ----------------------------------------------------------------

# Conexión del AttackTimer: signal timeout()
func _on_attack_timer_timeout():
	if not is_active or is_hurt:
		return

	# Usar "attack_" en MINÚSCULAS para coincidir con tus animaciones.
	var attack_name: String = "attack_" + str(attack_sequence)
	
	enemy_attack(attack_name)

# 🗡 FUNCIÓN DE ATAQUE (Integración de Sonido)
func enemy_attack(animation_name: String):
	is_hurt = true 
	
	# 🔊 SONIDO AL ATACAR
	sound_player.stream = SONIDO_PUMA
	sound_player.play()
	
	animacion_enemy.play(animation_name)
	
	enemy_hitbox.monitoring = true
	
	await animacion_enemy.animation_finished
	
	enemy_hitbox.monitoring = false
	
	is_hurt = false
	animacion_enemy.play("reposo")
	
	attack_sequence += 1
	if attack_sequence > 3:
		attack_sequence = 1
		
	attack_timer.start()

# CONEXIÓN DEL EnemyHitbox: signal body_entered(body)
func _on_enemy_hitbox_body_entered(body):
	if body.is_in_group("Cat"):
		if body.has_method("take_damage"):
			body.take_damage()
			
			# Solucionar el bloqueo usando set_deferred
			enemy_hitbox.set_deferred("monitoring", false)
