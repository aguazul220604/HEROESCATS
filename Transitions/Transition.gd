extends CanvasLayer

@onready var anim := $AnimationPlayer
@onready var transition_fx := preload("res://audio/audio.mp3")

func _ready():
	layer = -1
	anim.play("Transition2")

func change_scene(path: String) -> void:
	layer = 1
	anim.play("Transition2")
	await $AnimationPlayer.animation_finished

	get_tree().change_scene_to_file(path)

	anim.play_backwards("Transition2")
	await $AnimationPlayer.animation_finished
	layer = -1

	AudioPlayer.play_FX(transition_fx, -12.0)
