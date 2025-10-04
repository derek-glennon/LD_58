extends Button

@export var main_menu_scene : Node
@export var work_scenes: Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_pressed() -> void:
	main_menu_scene.visible = false
	work_scenes[PlayerController.stage].visible = true
