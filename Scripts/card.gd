class_name Card

extends TextureRect

@export var card_title := "Sample Name"
@export var card_description := "This is some sample card text"
@export var card_number := -1
@export var cost := 0
@export var rarity := Enums.Rarity.COMMON
@export var card_title_text : RichTextLabel
@export var card_description_text : RichTextLabel
@export var card_number_text : RichTextLabel
@export var card_rarity_text : RichTextLabel
@export var uncommon_color : Color
@export var rare_color : Color
@export var ultrarare_color : Color
@export var mystery_card : Button
@export var buy_single_button : Button
@export var cost_text : RichTextLabel
@export var collection_from_pack_duration := 1.0
@export var sell_from_pack_duration := 1.0

var is_unlocked := false
var money_ui
var collection_button_position := Vector2(0,0)

signal card_pack_animation_done

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_title_text.text = card_title
	card_description_text.text = card_description
	card_number_text.text = str(card_number)
	cost_text.text = str(cost) + " - Buy"
	match rarity:
		Enums.Rarity.COMMON:
			card_rarity_text.text = "C"
			card_rarity_text.add_theme_color_override("default_color", Color.WHITE)
		Enums.Rarity.UNCOMMON:
			card_rarity_text.text = "U"
			card_rarity_text.add_theme_color_override("default_color", uncommon_color)
		Enums.Rarity.RARE:
			card_rarity_text.text = "R"
			card_rarity_text.add_theme_color_override("default_color", rare_color)
		Enums.Rarity.ULTRARARE:
			card_rarity_text.text = "UR"
			card_rarity_text.add_theme_color_override("default_color", ultrarare_color)
	
	# Setup connections
	money_ui = PlayerController.money_ui
	
func on_unlock() -> void:
	is_unlocked = true	
	buy_single_button.visible = false
	
func clone_card(card: Card) -> void:
	self.texture = card.texture
	card_title = card.card_title
	card_title_text.text = card.card_title
	card_description = card.card_description
	card_description_text.text = card.card_description
	card_number = card.card_number
	card_number_text.text = str(card.card_number)
	rarity = card.rarity
	match rarity:
		Enums.Rarity.COMMON:
			card_rarity_text.text = "C"
			card_rarity_text.add_theme_color_override("default_color", Color.WHITE)
		Enums.Rarity.UNCOMMON:
			card_rarity_text.text = "U"
			card_rarity_text.add_theme_color_override("default_color", uncommon_color)
		Enums.Rarity.RARE:
			card_rarity_text.text = "R"
			card_rarity_text.add_theme_color_override("default_color", rare_color)
		Enums.Rarity.ULTRARARE:
			card_rarity_text.text = "UR"
			card_rarity_text.add_theme_color_override("default_color", ultrarare_color)
	is_unlocked = card.is_unlocked
	if !PlayerController.is_opening_pack:
		mystery_card.visible = !is_unlocked
	cost = card.cost
	cost_text.text = str(card.cost) + " - Buy"
	if PlayerController.current_scene == Enums.CurrentScene.BUY and !PlayerController.is_opening_pack:
		buy_single_button.visible = !card.is_unlocked

func _on_buy_single_button_pressed() -> void:
	if PlayerController.money >= cost:
		PlayerController.change_money(PlayerController.money - cost)
		var card_to_unlock = PlayerController.find_card_by_number(card_number)
		if card_to_unlock:
			PlayerController.unlock_card(card_to_unlock)

func _on_mystery_card_pressed() -> void:
	if mystery_card.self_modulate.a != 0:
		#play reveal animation
		mystery_card.self_modulate.a = 0
	else:
		mystery_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
		#play collect/sell animation
		var card = PlayerController.find_card_by_number(card_number)
		var index = PlayerController.unlocked_cards.find(card)
		if index == -1:
			PlayerController.unlock_card(card)
			play_collect_animation()
		else:
			play_sell_animation()
			
func play_collect_animation() -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", collection_button_position, collection_from_pack_duration)
	tween.tween_property(self, "scale", Vector2(0.0, 0.0), collection_from_pack_duration)
	tween.tween_callback(_on_collect_animation_done).set_delay(collection_from_pack_duration)

func _on_collect_animation_done() -> void:
	card_pack_animation_done.emit()
	queue_free()
	
func play_sell_animation() -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", money_ui.position, sell_from_pack_duration)
	tween.tween_property(self, "scale", Vector2(0.0, 0.0), sell_from_pack_duration)
	tween.tween_callback(_on_sell_animation_done).set_delay(sell_from_pack_duration)

func _on_sell_animation_done() -> void:
	var sell_cost = int(floor((cost * 0.25)))
	if sell_cost == 0:
		sell_cost = 1
	PlayerController.change_money(PlayerController.money + sell_cost)
	card_pack_animation_done.emit()
	queue_free()
	
