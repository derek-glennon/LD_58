extends Node2D

@export var main_menu_scene : Node
@export var pack_cost = 5
@export var rare_pack_cost = 20
@export var pack_spawn_point : Node
@export var back_button : Button
@export var collection_button : Button
@export var pack_button : Button
@export var rare_pack_button : Button
@export var buy_singles_scene : Node
@export var pack_scene : PackedScene
@export var rare_pack_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerController.stage_changed.connect(_on_stage_changed)

func _on_buy_pack_button_pressed() -> void:
	if PlayerController.money >= pack_cost:
		PlayerController.change_money(PlayerController.money - pack_cost)
		var pack = pack_scene.instantiate()
		pack_spawn_point.add_child(pack)

func _on_back_button_pressed() -> void:
	main_menu_scene.visible = true
	visible = false
	PlayerController.change_current_scene(Enums.CurrentScene.MAIN)
	
func _on_stage_changed(new_value : int) -> void:
	if new_value == 1:
		pack_button.visible = true
		rare_pack_button.visible = false
		buy_singles_scene.visible = false
	elif new_value == 2:
		pack_button.visible = true
		rare_pack_button.visible = true
		buy_singles_scene.visible = false
	elif new_value == 3:
		pack_button.visible = false
		rare_pack_button.visible = false
		buy_singles_scene.visible = true
		
