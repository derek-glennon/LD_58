extends Button

@export var main_menu_scene : Node
@export var buy_scene : Node
@export var collection_scene : Node
var previous_scene := Enums.CurrentScene.MAIN

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	collection_scene.visible = !collection_scene.visible

	if collection_scene.visible:
		if PlayerController.current_scene == Enums.CurrentScene.MAIN:
			main_menu_scene.visible = false
			previous_scene = Enums.CurrentScene.MAIN
		elif PlayerController.current_scene == Enums.CurrentScene.BUY:
			buy_scene.visible = false
			previous_scene = Enums.CurrentScene.BUY
			PlayerController.change_current_scene(Enums.CurrentScene.COLLECTION)
	else:
		if previous_scene == Enums.CurrentScene.MAIN:
			main_menu_scene.visible = true
		elif previous_scene == Enums.CurrentScene.BUY:
			buy_scene.visible = true
		PlayerController.change_current_scene(previous_scene)
