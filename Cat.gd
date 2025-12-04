extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var umbral = 1000
var Door = false

@onready var cat = $Sprite2D_Cat
@onready var animacion_cat = $AnimationPlayer_Cat
@onready var hitbox = $Hitbox_Attack

func _ready():
	update_hearts()
	# Desactivar el hitbox al inicio
	hitbox.monitoring = false
	hitbox.monitorable = false

func _process(delta):
	if Door:
		Open_Door()

func Open_Door():
	Door = false
	set_physics_process(false)
	set_process(false)
	animacion_cat.play("Idle")
	await animacion_cat.animation_finished

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 🗡 ATAQUE
	if Input.is_action_just_pressed("attack_2") and not Global.is_hurt:
		attack_action()

	# 🦘 SALTO
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 🚶 MOVIMIENTO
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	animaciones(direction)
	move_and_slide()

	# VOLTEAR SPRITE
	if direction == 1:
		cat.flip_h = false
	elif direction == -1:
		cat.flip_h = true

# 🗡 FUNCIÓN DE ATAQUE
func attack_action():
	hitbox.monitoring = true
	hitbox.monitorable = true
	animacion_cat.play("Attack_2")
	await animacion_cat.animation_finished
	hitbox.monitoring = false
	hitbox.monitorable = false

func animaciones(direction):
	# DEATH
	if velocity.y > umbral:
		animacion_cat.play("Death")
		return

	# HURT
	if Global.is_hurt:
		animacion_cat.play("Hurt")
		return

	# AIRE
	if not is_on_floor():
		if velocity.y < 0:
			animacion_cat.play("Jump")
		else:
			animacion_cat.play("Jump")
		return

	# MOVIMIENTO
	if direction != 0:
		animacion_cat.play("Walk")
		return

	# IDLE
	animacion_cat.play("Idle")

func _on_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")

# 🩹 RECIBIR DAÑO
func take_damage():
	if Global.is_hurt:
		return

	Global.is_hurt = true
	Global.lives -= 1
	update_hearts()

	animacion_cat.play("Hurt")
	await animacion_cat.animation_finished

	# ❌ Ya NO reiniciamos las vidas aquí
	# ❌ Ya NO dejamos al jugador vivir indefinidamente

	# ✔ Si las vidas llegan a 0 → GAME OVER / POWERED
	if Global.lives <= 0:
		Global.is_hurt = false
		get_tree().change_scene_to_file("res://lose.tscn")
		return

	# ✔ Si aún tiene vidas → seguir normal
	Global.is_hurt = false

# ❤️ VIDA UI
func update_hearts():
	var container := get_node("CanvasLayer")

	var hearts := [
		[container.get_node("Sprite2D_7"), container.get_node("Sprite2D_14")],
		[container.get_node("Sprite2D_6"), container.get_node("Sprite2D_13")],
		[container.get_node("Sprite2D_5"), container.get_node("Sprite2D_12")],
		[container.get_node("Sprite2D_4"), container.get_node("Sprite2D_11")],
		[container.get_node("Sprite2D_3"), container.get_node("Sprite2D_10")],
		[container.get_node("Sprite2D_2"), container.get_node("Sprite2D_9")],
		[container.get_node("Sprite2D_1"), container.get_node("Sprite2D_8")]
	]

	for i in range(Global.max_lives):
		var full = hearts[i][0]
		var empty = hearts[i][1]

		if i < Global.lives:
			full.visible = true
			empty.visible = false
		else:
			full.visible = false
			empty.visible = true

# 🗡 GOLPÉA ENEMIGO
func _on_hitbox_attack_body_entered(body):
	if body.is_in_group("Enemy"):
		body.die()
