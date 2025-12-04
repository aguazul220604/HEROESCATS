extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_inicio_pressed() -> void:
	Transition.change_scene("res://powered.tscn")

func _on_reiniciar_pressed() -> void:
	var scene_path = get_tree().current_scene.scene_file_path
	if scene_path != "":
		get_tree().change_scene_to_file(scene_path)

func _on_salir_pressed() -> void: 
	get_tree().quit()
