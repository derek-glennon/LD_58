class_name GrassPattern

extends Node2D

var grass_spaces: Array[GrassSpace] = []
var current_mowed := 0
var max_mowed := 0

signal all_mowed

func init() -> void:
	for child in get_children():
		var grass_space = child as GrassSpace
		if grass_space:
			grass_spaces.append(grass_space)
			grass_space.on_mowed.connect(_on_grass_space_mowed)
			max_mowed += 1
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_grass_space_mowed() -> void:
	current_mowed += 1
	if current_mowed == max_mowed:
		all_mowed.emit()
