class_name CardPack

extends Button

@export var is_rare := false
@export var cards: Array[Card] = []

signal all_cards_opened

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_generate_cards()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	self_modulate.a = 0
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	cards[0].mystery_card.mouse_filter = Control.MOUSE_FILTER_STOP
	for card in cards:
		card.card_pack_animation_done.connect(_on_card_animation_done)
		card.visible = true

func set_collection_button_position_on_cards(new_position : Vector2) -> void:
	for card in cards:
		card.collection_button_position = new_position

func _generate_cards() -> void:
	var common_cards := PlayerController.all_cards.filter(func(card : Card): return card.rarity == Enums.Rarity.COMMON)
	var uncommon_cards := PlayerController.all_cards.filter(func(card : Card): return card.rarity == Enums.Rarity.UNCOMMON)
	var rare_cards := PlayerController.all_cards.filter(func(card : Card): return card.rarity == Enums.Rarity.RARE)
	var ultrarare_cards := PlayerController.all_cards.filter(func(card : Card): return card.rarity == Enums.Rarity.ULTRARARE)
	
	var rng = RandomNumberGenerator.new()
	var random_one = rng.randf()
	var random_two = rng.randf()
	var random_three = rng.randf()
	
	var rarity_one
	var rarity_two
	var rarity_three
	if !is_rare:
		rarity_one = Enums.Rarity.COMMON if random_one < 0.75 else Enums.Rarity.UNCOMMON
		rarity_two = Enums.Rarity.COMMON if random_two < 0.75 else Enums.Rarity.UNCOMMON
		rarity_three = Enums.Rarity.UNCOMMON if random_three < 0.95 else Enums.Rarity.RARE
	else:
		rarity_one = Enums.Rarity.UNCOMMON if random_one < 0.75 else Enums.Rarity.RARE
		rarity_two = Enums.Rarity.UNCOMMON if random_two < 0.75 else Enums.Rarity.RARE
		rarity_three = Enums.Rarity.RARE if random_three < 0.95 else Enums.Rarity.ULTRARARE
		
	cards[0].rarity = rarity_one
	cards[1].rarity = rarity_two
	cards[2].rarity = rarity_three
	
	for card in cards:
		var new_card
		match card.rarity:
			Enums.Rarity.COMMON:
				new_card = common_cards.pick_random()
			Enums.Rarity.UNCOMMON:
				new_card = uncommon_cards.pick_random()
			Enums.Rarity.RARE:
				new_card = rare_cards.pick_random()
			Enums.Rarity.ULTRARARE:
				new_card = ultrarare_cards.pick_random()
		card.clone_card(new_card)
		
func _on_card_animation_done() -> void:
	cards.remove_at(0)
	if cards.size() != 0:
		cards[0].mystery_card.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		all_cards_opened.emit()
