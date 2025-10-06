class_name MainMenu

extends Node2D

@export var keys : Sprite2D
@export var job_offer : Sprite2D

func on_stage_changed(new_stage : int) -> void:
	match new_stage:
		2:
			keys.visible = true
		3:
			keys.visible = true
			job_offer.visible = true
