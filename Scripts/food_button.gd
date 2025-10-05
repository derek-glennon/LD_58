class_name FoodButton

extends Button

@export var work_scene : Node
@export var food_item_scene : PackedScene

var is_active := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_down() -> void:
	if is_active:
		var food_item = food_item_scene.instantiate()
		food_item.global_position = get_viewport().get_mouse_position()
		work_scene.add_child(food_item)
