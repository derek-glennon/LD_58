class_name CollectionGrid

extends GridContainer

var current_page = 0
@export var max_page = -1
@export var visible_cards: Array[Card] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerController.card_unlocked.connect(_on_card_unlocked)
	
func init() -> void:
	max_page = (PlayerController.all_cards.size() / 8) - 1
	for i in range(visible_cards.size()):
		visible_cards[i].clone_card(PlayerController.all_cards[current_page + i])
	
func _on_card_unlocked(card: Card) -> void:
	card.buy_single_button.visible = false
	var index_min = current_page * 8
	var index_max = index_min + 7
	if (card.card_number - 1) >= index_min and (card.card_number - 1) <= index_max:
		var visible_index = (card.card_number - 1) - (current_page * 8)
		visible_cards[visible_index].clone_card(card)

func _on_right_button_pressed() -> void:
	if current_page < max_page:
		current_page += 1
		update_visible_cards()

func _on_left_button_pressed() -> void:
	if current_page > 0:
		current_page -= 1
		update_visible_cards()
			
func update_visible_cards() -> void:
	for i in range(visible_cards.size()):
		var card_index = (current_page * 8) + i
		if card_index < PlayerController.all_cards.size():
			visible_cards[i].visible = true
			visible_cards[i].clone_card(PlayerController.all_cards[card_index])
		else:
			visible_cards[i].visible = false	
