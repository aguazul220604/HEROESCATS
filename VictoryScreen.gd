extends Control 

const MENU_SCENE_PATH = "res://menu.tscn" 

func _ready() -> void:
	# Pausa el juego
	get_tree().paused = true

# Asegúrate que el nombre sea TODO EN MINÚSCULAS y conectado a la señal
func _on_boton_menu_pressed() -> void:
	# 1. DESPAUSAR
	get_tree().paused = false
	
	# 2. CAMBIAR ESCENA
	get_tree().change_scene_to_file(MENU_SCENE_PATH)
	
	# NO es necesario queue_free() aquí si change_scene_to_file() funciona.
