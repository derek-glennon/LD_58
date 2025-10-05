class_name Mower

extends Node2D

#@export var movement_delay = 0.0
@export var movement_offset := 100
@export var hit_delay := 1.0
@export var collision_shape : CollisionShape2D

var can_move := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if PlayerController.current_scene == Enums.CurrentScene.WORK:
		if PlayerController.stage == 1:
			if can_move:
				global_position = get_viewport().get_mouse_position()
			#if can_move:
				#var difference = position - get_viewport().get_mouse_position()
				#if abs(difference.x) > abs(difference.y):
					#if abs(difference.x) > movement_offset:
						#position.x += movement_offset * -sign(difference.x)
						#var timer = get_tree().create_timer(movement_delay)
						#timer.timeout.connect(_on_movement_delay_done)
						#can_move = false
				#elif abs(difference.y) > abs(difference.x):
					#if abs(difference.y) > movement_offset:
						#position .y += movement_offset * -sign(difference.y)
						#var timer = get_tree().create_timer(movement_delay)
						#timer.timeout.connect(_on_movement_delay_done)
						#can_move = false

#func _on_movement_delay_done() -> void:
	#can_move = true
	
func on_hit_rock() -> void:
	set_can_move(false)
	var timer = get_tree().create_timer(hit_delay)
	timer.timeout.connect(_on_hit_delay_done)
	
func _on_hit_delay_done() -> void:
	set_can_move(true)
	
func set_can_move(new_value: bool) ->void:
	can_move = new_value
	collision_shape.set_deferred("disabled", !new_value)
	
