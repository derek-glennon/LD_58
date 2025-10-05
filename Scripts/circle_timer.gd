class_name CircleTimer

extends TextureRect

var time_max := 0.0
var current_time := 0.0
var is_on := false

signal timer_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func start_timer(new_time_max: float) -> void:
	time_max = new_time_max
	current_time = 0.0
	material.set("shader_parameter/time_max", time_max)
	is_on = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_on:
		current_time += delta
		if current_time >= time_max:
			current_time = time_max
			is_on = false
			timer_finished.emit()
		material.set("shader_parameter/current_time", current_time)
