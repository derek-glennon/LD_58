extends Button

@export var is_rare := false
@export var cards: Array[Card] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	self_modulate.a = 0
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	for card in cards:
		card.visible = true
		card.mystery_card.mouse_filter = Control.MOUSE_FILTER_STOP
