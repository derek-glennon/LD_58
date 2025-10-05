class_name MoneyUI

extends HBoxContainer

@export var money_text : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerController.money_ui = self
	PlayerController.money_amount_changed.connect(_on_money_amount_changed)

func _on_money_amount_changed(new_value: int) -> void:
	money_text.text = str(new_value)
