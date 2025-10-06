class_name StageThreeWorkController

extends Node2D

@export var main_menu_scene : Node
@export var coin_scene : PackedScene
@export var instructions_text : RichTextLabel
@export var starting_phrases : Array[String] = []
@export var starting_delay := 3
@export var command_delay := 3
@export var after_input_delay := 1
@export var after_answer_delay := 3
@export var circle_timer : CircleTimer
@export var work_time_max := 30.0
@export var end_of_work_delay := 4.0
@export var random_inputs : Array[String] = []
@export var command_phrases : Array[String] = []
@export var correct_phrases : Array[String] = []
@export var incorrect_phrases : Array[String] = []
@export var celebration_phrases : Array[String] = []

var expected_input := ""
var is_waiting_for_input := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init() -> void:
	var starting_phrase_index = PlayerController.day - 1
	if starting_phrase_index >= starting_phrases.size():
		starting_phrase_index = starting_phrases.size() - 1
	instructions_text.text = starting_phrases[starting_phrase_index]
	var timer = get_tree().create_timer(starting_delay)
	timer.timeout.connect(_on_starting_delay_over)

func _on_starting_delay_over() -> void:
		instructions_text.text = "Getting important work..."
		var timer = get_tree().create_timer(command_delay)
		timer.timeout.connect(_on_command_delay_over)
		circle_timer.start_timer(work_time_max)
		if !circle_timer.timer_finished.is_connected(_on_work_time_over):
			circle_timer.timer_finished.connect(_on_work_time_over)
	
func _on_after_answer_delay_over() -> void:
	if circle_timer.is_on:
		instructions_text.text = "Getting important work..."
		var timer = get_tree().create_timer(command_delay)
		timer.timeout.connect(_on_command_delay_over)
	
func _on_command_delay_over() -> void:
	if circle_timer.is_on:
		expected_input = random_inputs.pick_random()
		var key := expected_input.substr(4)
		instructions_text.text = "Press " + key + " " + command_phrases.pick_random()
		is_waiting_for_input = true	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if PlayerController.current_scene == Enums.CurrentScene.WORK:
		if circle_timer.is_on:
			if is_waiting_for_input:
				if Input.is_anything_pressed():
					if Input.is_action_just_pressed(expected_input):
						instructions_text.text = ""
						var timer = get_tree().create_timer(after_input_delay)
						timer.timeout.connect(_on_correct_input)
						is_waiting_for_input = false
					else:
						instructions_text.text = ""
						var timer = get_tree().create_timer(after_input_delay)
						timer.timeout.connect(_on_incorrect_input)
						is_waiting_for_input = false
			
func _on_correct_input() -> void:
	if circle_timer.is_on:
		instructions_text.text = correct_phrases.pick_random()
		var timer = get_tree().create_timer(after_answer_delay)
		timer.timeout.connect(_on_after_answer_delay_over)
		for i in range(100):
			await get_tree().create_timer(0.01).timeout
			_on_emit_coin(coin_scene.instantiate(), Vector2(960, 540), 0.5)

func _on_incorrect_input() -> void:
	if circle_timer.is_on:
		instructions_text.text = incorrect_phrases.pick_random()
		var timer = get_tree().create_timer(after_answer_delay)
		timer.timeout.connect(_on_after_answer_delay_over)
	
func _on_work_time_over() -> void:
	instructions_text.text = celebration_phrases.pick_random()
	var timer = get_tree().create_timer(end_of_work_delay)
	timer.timeout.connect(_on_end_of_work_delay_over)
	for i in range(200):
		await get_tree().create_timer(0.01).timeout
		_on_emit_coin(coin_scene.instantiate(), Vector2(960, 540), 0.5)
			
func _on_end_of_work_delay_over() -> void:
	instructions_text.text = ""
	PlayerController.change_current_scene(Enums.CurrentScene.MAIN)
	PlayerController.change_day(PlayerController.day + 1)
	main_menu_scene.visible = true
	visible =  false
	
func _on_emit_coin(coin : Node, start_position : Vector2, duration : float) -> void:
	var new_coin = coin as Coin
	add_child(new_coin)
	new_coin.global_position = start_position
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(new_coin, "position", PlayerController.money_ui.position, duration)
	tween.tween_property(new_coin, "scale", Vector2(0.2, 0.2), duration)
	tween.tween_callback(new_coin.play_audio).set_delay(duration)
	var timer = get_tree().create_timer(duration)
	timer.timeout.connect(_on_coin_collected)
	
func _on_coin_collected() -> void:
	PlayerController.change_money(PlayerController.money + 1)
