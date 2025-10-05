extends Node2D

@export var main_menu_scene : Node
@export var pack_cost = 5
@export var rare_pack_cost = 20
@export var pack_spawn_point : Node
@export var back_button : Button
@export var collection_button : Button
@export var pack_button : Button
@export var rare_pack_button : Button
@export var buy_singles_button : Button
@export var buy_singles_scene : Node
@export var pack_scene : PackedScene
@export var rare_pack_scene : PackedScene

var opening_pack : CardPack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerController.stage_changed.connect(_on_stage_changed)		

func _on_buy_pack_button_pressed() -> void:
	if PlayerController.money >= pack_cost:
		PlayerController.change_money(PlayerController.money - pack_cost)
		_toggle_for_pack_opening(true)
		opening_pack = pack_scene.instantiate()
		opening_pack.all_cards_opened.connect(_on_all_cards_opened)
		opening_pack.set_collection_button_position_on_cards(collection_button.position)
		pack_spawn_point.add_child(opening_pack)
		
func _on_buy_rare_pack_button_pressed() -> void:
	if PlayerController.money >= rare_pack_cost:
		PlayerController.change_money(PlayerController.money - rare_pack_cost)
		_toggle_for_pack_opening(true)
		opening_pack = rare_pack_scene.instantiate()
		opening_pack.all_cards_opened.connect(_on_all_cards_opened)
		opening_pack.set_collection_button_position_on_cards(collection_button.position)
		pack_spawn_point.add_child(opening_pack)
		
func _on_buy_singles_button_pressed() -> void:
	pack_button.visible = false
	rare_pack_button.visible = false
	buy_singles_button.visible = false
	buy_singles_scene.visible = true

func _on_back_button_pressed() -> void:
	if buy_singles_scene.visible:
		pack_button.visible = true
		rare_pack_button.visible = true
		buy_singles_button.visible = true
		buy_singles_scene.visible = false
	else:
		main_menu_scene.visible = true
		visible = false
		PlayerController.change_current_scene(Enums.CurrentScene.MAIN)
	
func _on_stage_changed(new_value : int) -> void:
	_set_visibility_for_stage(new_value)
		
func _set_visibility_for_stage(stage_value : int) -> void:
	if stage_value == 1:
		pack_button.visible = true
		rare_pack_button.visible = false
		buy_singles_button.visible = false
	elif stage_value == 2:
		pack_button.visible = true
		rare_pack_button.visible = true
		buy_singles_button.visible = false
	elif stage_value == 3:
		pack_button.visible = true
		rare_pack_button.visible = true
		buy_singles_button.visible = true

func _toggle_for_pack_opening(is_opening: bool) -> void:
	PlayerController.is_opening_pack = is_opening
	pack_button.visible = !is_opening
	if PlayerController.stage >= 2:
		rare_pack_button.visible = !is_opening
	if PlayerController.stage >= 3:
		buy_singles_button.visible = !is_opening
	back_button.visible = !is_opening
	collection_button.visible = !is_opening
		
func _on_all_cards_opened() ->void:
	_toggle_for_pack_opening(false)
	opening_pack.queue_free()
