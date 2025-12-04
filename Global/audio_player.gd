extends Node

@onready var music_player := AudioStreamPlayer.new()

const LEVEL_MUSIC := preload("res://audio/audio.mp3")

func _ready():
	music_player.bus = "Music"
	add_child(music_player)


func _play_music(music: AudioStream, volume := 0.0):
	if music_player.stream == music:
		return
	music_player.stream = music
	music_player.volume_db = volume
	music_player.play()


func play_music_level():
	_play_music(LEVEL_MUSIC)


func play_FX(stream: AudioStream, volume := 0.0):
	var fx_player := AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.bus = "SFX"
	fx_player.volume_db = volume
	add_child(fx_player)

	fx_player.play()
	await get_tree().create_timer(stream.get_length()).timeout
	fx_player.queue_free()
