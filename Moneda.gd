extends Area2D

@onready var mb = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mb.play("moneda")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Cat"):
		print("conseguiste una moneda")
		queue_free()
