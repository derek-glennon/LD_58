class_name ThanksForPlayingScene

extends Node2D

@export var delay_before_congrats = 3
@export var screen_time = 10

func _ready() -> void:
	PlayerController.all_cards_unlocked.connect(_on_all_cards_unlocked)
	
func _on_all_cards_unlocked() ->void:
	var timer = get_tree().create_timer(delay_before_congrats)
	timer.timeout.connect(_on_delay_before_congrats_over)
	
func _on_delay_before_congrats_over() -> void:
	visible = true
	var timer = get_tree().create_timer(screen_time)
	timer.timeout.connect(_on_screen_time_over)
	
func _on_screen_time_over() ->void:
	visible = false
