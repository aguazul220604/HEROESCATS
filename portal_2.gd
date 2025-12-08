extends Area2D

@onready var anim_portal = $AnimatedSprite2D
@onready var tiempo = $Timer
@onready var collision = $CollisionShape2D

func _ready():
	anim_portal.play("portal_2")
	
func _on_body_entered(body):
	if body.is_in_group("Cat"): 
		body.Door = true
		collision.queue_free()
		anim_portal.play("portal_2")
		tiempo.start()
		await tiempo.timeout
		get_tree().change_scene_to_file("res://level_2_up.tscn")
		
