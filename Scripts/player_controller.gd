extends Node2D

var money := 0
var card_path := "res://Prefabs/Cards/"
var all_cards: Array[Card] = []
var locked_cards: Array[Card] = []
var unlocked_cards: Array[Card] = []
var collection_grid
var day := 1
var stage := 1
var current_scene := Enums.CurrentScene.MAIN
var is_opening_pack := false
var money_ui

signal card_unlocked
signal money_amount_changed
signal current_scene_changed
signal day_changed
signal stage_changed
signal all_cards_unlocked

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
	if Input.is_action_just_pressed("debug 2"):
		money += 1
		change_money(money)
	if Input.is_action_just_pressed("debug add 100"):
		money += 100
		change_money(money)
	if Input.is_action_just_pressed("debug day 1"):
		change_day(1)
	if Input.is_action_just_pressed("debug day 2"):
		change_day(2)
	if Input.is_action_just_pressed("debug day 3"):
		change_day(3)
	if Input.is_action_just_pressed("debug stage 1"):
		change_stage(1)
	if Input.is_action_just_pressed("debug stage 2"):
		change_stage(2)
	if Input.is_action_just_pressed("debug stage 3"):
		change_stage(3)
	
func find_card_by_number(card_number: int) -> Card:
	for card in all_cards:
		if card_number == card.card_number:
			return card
	return null

func unlock_card(card: Card):
	card.on_unlock()
	var index = locked_cards.find(card)
	unlocked_cards.append(locked_cards.get(index))
	unlocked_cards.sort_custom(HelperFunctions.sort_cards_by_number)
	locked_cards.remove_at(index)
	locked_cards.sort_custom(HelperFunctions.sort_cards_by_number)
	card_unlocked.emit(card)
	
	if locked_cards.size() == 0:
		all_cards_unlocked.emit()
	
func change_money(new_value : int) -> void:
	money = new_value
	money_amount_changed.emit(new_value)
	
func change_current_scene (new_value : Enums.CurrentScene) -> void:
	current_scene = new_value
	current_scene_changed.emit(new_value)
	
func change_stage(new_value: int) -> void:
	stage = new_value
	stage_changed.emit(new_value)
	
func change_day(new_value: int) -> void:
	day = new_value
	day_changed.emit(new_value)
