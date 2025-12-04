extends CharacterBody2D

const SPEED = 90
const GRAVITY = 98

@onready var anim := $AnimatedSprite2D

func _ready():
	velocity.x = -SPEED
	anim.play("Walk")

func _physics_process(delta):
	velocity.y += GRAVITY

	# Cambiar dirección al chocarse con paredes
	if is_on_wall():
		velocity.x = -velocity.x

	# Voltear sprite
	anim.flip_h = velocity.x > 0

	move_and_slide()

# Daño al Cat
func _on_Hurtbox_body_entered(body):
	if body.is_in_group("Cat"):
		body.take_damage()

# Morir cuando el Cat lo ataca
func die():
	if anim.has_animation("Death"):
		anim.play("Death")
		await get_tree().create_timer(0.3).timeout
	queue_free()
