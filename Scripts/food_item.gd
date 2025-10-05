class_name FoodItem

extends Button

@export var food_type : Enums.FoodTypes
@export var offset := Vector2(-75.0, -75.0)
@export var collision_shape : CollisionShape2D

var is_held := true
var over_trash := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_held:
		global_position = get_viewport().get_mouse_position() + offset
		if Input.is_action_just_released("Click"):
			is_held = false
			if over_trash:
				queue_free()

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	var trash = area.get_parent() as TrashCan
	if trash:
		over_trash = true

func _on_area_2d_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	var trash = area.get_parent() as TrashCan
	if trash:
		over_trash = false

func _on_button_down() -> void:
	is_held = true
