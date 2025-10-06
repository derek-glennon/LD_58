class_name CollectionButton

extends Button

@export var main_menu_scene : Node
@export var buy_scene : Node
@export var collection_scene : Node
@export var collection_grid : CollectionGrid
var previous_scene := Enums.CurrentScene.MAIN
@export var audio_player : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerController.current_scene_changed.connect(_on_scene_changed)

func _on_pressed() -> void:
	audio_player.play()
	collection_scene.visible = !collection_scene.visible

	if collection_scene.visible:
		if PlayerController.current_scene == Enums.CurrentScene.MAIN:
			main_menu_scene.visible = false
			previous_scene = Enums.CurrentScene.MAIN
		elif PlayerController.current_scene == Enums.CurrentScene.BUY:
			buy_scene.visible = false
			previous_scene = Enums.CurrentScene.BUY
		PlayerController.change_current_scene(Enums.CurrentScene.COLLECTION)
		collection_grid.update_visible_cards()
	else:
		if previous_scene == Enums.CurrentScene.MAIN:
			main_menu_scene.visible = true
		elif previous_scene == Enums.CurrentScene.BUY:
			buy_scene.visible = true
		PlayerController.change_current_scene(previous_scene)


func _on_scene_changed(new_value : Enums.CurrentScene) -> void:
	if new_value == Enums.CurrentScene.WORK:
		visible = false
	else:
		visible = true
