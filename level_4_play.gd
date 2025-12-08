extends Node2D # Usa el tipo de nodo raíz de tu escena

# ... (Otras variables y funciones que ya tengas)

func _ready() -> void:
	# Esta función se llama al iniciar el nivel
	iniciar_flamas()
	
	# ... (Cualquier otro código que tengas en _ready)

# Función para forzar la reproducción de todas las flamas
func iniciar_flamas():
	# 1. Obtiene una lista de todos los nodos que están en el grupo "flamas"
	# Este paso utiliza el grupo que creaste.
	var lista_flamas = get_tree().get_nodes_in_group("flamas")
	
	# 2. Recorre la lista de flamas, iniciando la animación en cada nodo
	for flama_node in lista_flamas:
		# 3. Verifica que el nodo sea un AnimatedSprite2D antes de intentar reproducir
		if flama_node is AnimatedSprite2D:
			# 4. Inicia la animación llamada "fire"
			flama_node.play("fire")
