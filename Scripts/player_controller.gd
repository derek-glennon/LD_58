extends Node2D

var money := 0
var card_path := "res://Prefabs/Cards/"
var all_cards: Array[Card] = []
var locked_cards: Array[Card] = []
var unlocked_cards: Array[Card] = []

var collection_grid

signal card_unlocked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var cards = HelperFunctions.load_scenes_from_directory(card_path)
	for card in cards:
		var newCard := card.instantiate() as Card
		if newCard:
			all_cards.append(newCard)
			locked_cards.append(newCard)
	all_cards.sort_custom(HelperFunctions.sort_cards_by_number)
	locked_cards.sort_custom(HelperFunctions.sort_cards_by_number)
	
	# Setup connections
	var nodes = HelperFunctions.get_all_children($"..")
	for node in nodes:
		var node_grid := node as CollectionGrid
		if node_grid:
			collection_grid = node_grid
			collection_grid.init()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug 1"):
		var card_to_unlock = locked_cards.pick_random()
		if card_to_unlock:
			unlock_card(card_to_unlock)
	pass
	
func unlock_card(card: Card):
	card.on_unlock()
	var index = locked_cards.find(card)
	unlocked_cards.append(locked_cards.get(index))
	unlocked_cards.sort_custom(HelperFunctions.sort_cards_by_number)
	locked_cards.remove_at(index)
	locked_cards.sort_custom(HelperFunctions.sort_cards_by_number)
	card_unlocked.emit(card)
