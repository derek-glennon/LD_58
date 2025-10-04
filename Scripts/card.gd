class_name Card

extends TextureRect

@export var card_number := -1
@export var cost := 0
@export var rarity := Enums.Rarity.COMMON
@export var card_text : RichTextLabel
@export var card_number_text : RichTextLabel
@export var mystery_card : Button
@export var buy_single_button : Button
@export var cost_text : RichTextLabel

var is_unlocked := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_number_text.text = str(card_number)
	cost_text.text = str(cost) + " - Buy"
	
func on_unlock() -> void:
	is_unlocked = true	
	buy_single_button.visible = false
	
func clone_card(card: Card) -> void:
	self.texture = card.texture
	card_text.text = card.card_text.text
	card_number = card.card_number
	card_number_text.text = str(card.card_number)
	is_unlocked = card.is_unlocked
	mystery_card.visible = !is_unlocked
	cost = card.cost
	cost_text.text = str(card.cost) + " - Buy"
	if PlayerController.current_scene == Enums.CurrentScene.BUY:
		buy_single_button.visible = !card.is_unlocked

func _on_buy_single_button_pressed() -> void:
	if PlayerController.money >= cost:
		PlayerController.change_money(PlayerController.money - cost)
		var card_to_unlock = PlayerController.find_card_by_number(card_number)
		if card_to_unlock:
			PlayerController.unlock_card(card_to_unlock)

func _on_mystery_card_pressed() -> void:
	prints("mystery card pressed")
