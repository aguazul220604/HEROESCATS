extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var umbral = 1000

@onready var cat = $Sprite2D_Cat
@onready var animacion_cat = $AnimationPlayer_Cat

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Saltar
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimiento horizontal
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	animaciones(direction)
	move_and_slide()

	if direction == 1:
		cat.flip_h = false
	elif direction == -1:
		cat.flip_h = true

func animaciones(direction):
	# DEATH
	if velocity.y > umbral:
		animacion_cat.play("Death")
		return

	# HURT
	if Global.is_hurt:
		animacion_cat.play("Hurt")
		return

	# ATTACK
	if Input.is_action_just_pressed("attack"):
		var ataque = randi() % 3 + 1
		animacion_cat.play("Attack_" + str(ataque))
		return

	# AIRE
	if not is_on_floor():
		if velocity.y < 0:
			animacion_cat.play("Jump")
		else:
			animacion_cat.play("Jump") # O "Fall"
		return

	# MOVIMIENTO
	if direction != 0:
		animacion_cat.play("Walk")
		return

	# IDLE
	animacion_cat.play("Idle")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://powered.tscn")
