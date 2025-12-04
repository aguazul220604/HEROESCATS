extends Area2D

@onready var raton = $AnimatedSprite2D1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	raton.play("Walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Cat"):
		print("conseguiste daño")
		queue_free()
