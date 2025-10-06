class_name Coin

extends TextureRect

@export var audio_player : AudioStreamPlayer

func play_audio() -> void:
	audio_player.play()
	visible = false

func _on_audio_stream_player_finished() -> void:
	queue_free()
