extends Button

@export var main_menu_scene : Node
@export var work_scenes: Array[Node] = []

@export var work_controller_1 : StageOneWorkController
@export var work_controller_3 : StageThreeWorkController
var work_controller_2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_pressed() -> void:
	main_menu_scene.visible = false
	work_scenes[PlayerController.stage - 1].visible = true
	PlayerController.change_current_scene(Enums.CurrentScene.WORK)
	match PlayerController.stage:
		1:	
			work_controller_1.init()
		2:
			work_controller_3.init()
		3:
			work_controller_3.init()
