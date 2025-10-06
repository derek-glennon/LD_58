extends Button

@export var main_menu_scene : Node
@export var buy_scene : Node

@export var audio_player : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_pressed() -> void:
	audio_player.play()
	main_menu_scene.visible = false
	buy_scene.visible = true
	PlayerController.change_current_scene(Enums.CurrentScene.BUY)
