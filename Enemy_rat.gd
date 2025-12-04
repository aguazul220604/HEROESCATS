extends Area2D

@onready var rata = $AnimatedSprite2D
@onready var ray = $Ray

var speed := 50
var direction := -1  # -1 = izquierda, 1 = derecha

func _ready() -> void:
	rata.play("Walk_rat")

func _physics_process(delta: float) -> void:
	# Movimiento
	position.x += direction * speed * delta

	# Detectar pared con RayCast2D
	if ray.is_colliding():
		direction *= -1  # Cambiar dirección
		scale.x *= -1     # Voltear sprite
		ray.position.x *= -1  # Mover raycast al otro lado

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Cat"):
		print("conseguiste una moneda")
		queue_free()
