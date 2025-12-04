extends Control

func _ready():
	AudioPlayer.play_music_level()

func _on_button_pressed():
	Transition.change_scene("res://presentation.tscn")
