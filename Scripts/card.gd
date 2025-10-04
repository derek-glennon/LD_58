class_name Card

extends TextureRect

@export var card_number := -1
@export var cost := 0
@export var rarity := Enums.Rarity.COMMON
@export var card_text : RichTextLabel
@export var card_number_text : RichTextLabel
@export var mystery_card : TextureRect

var is_unlocked := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_number_text.text = str(card_number)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_unlock() -> void:
	is_unlocked = true	
	
func clone_card(card: Card) -> void:
	self.texture = card.texture
	card_text.text = card.card_text.text
	card_number = card.card_number
	card_number_text.text = str(card.card_number)
	is_unlocked = card.is_unlocked
	mystery_card.visible = !is_unlocked
