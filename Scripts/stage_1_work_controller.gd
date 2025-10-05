class_name StageOneWorkController

extends Node2D

@export var main_menu_scene : Node
@export var grass_controller : GrassController
@export var instructions_text : RichTextLabel
@export var instructions_delay := 2.0
@export var instructions_phrases : Array[String] = []
@export var mower : Mower
@export var work_time_max := 30.0
@export var end_of_work_delay := 3.0
@export var celebration_phrases: Array[String] = []
@export var circle_timer : CircleTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init() -> void:
	instructions_text.text = instructions_phrases[PlayerController.day - 1]
	var timer = get_tree().create_timer(instructions_delay)
	timer.timeout.connect(_on_instruction_delay_over)
	grass_controller.init()

func _on_instruction_delay_over() -> void:
	mower.set_can_move(true)
	instructions_text.text = ""
	circle_timer.start_timer(work_time_max)
	if !circle_timer.timer_finished.is_connected(_on_work_time_over):
		circle_timer.timer_finished.connect(_on_work_time_over)

func _on_work_time_over() -> void:
	mower.set_can_move(false)
	instructions_text.text = celebration_phrases.pick_random()
	var timer = get_tree().create_timer(end_of_work_delay)
	timer.timeout.connect(_on_end_of_work_delay_over)

func _on_end_of_work_delay_over() -> void:
	PlayerController.change_current_scene(Enums.CurrentScene.MAIN)
	var next_day = PlayerController.day + 1
	if next_day > 3:
		PlayerController.change_stage(2)
		PlayerController.change_day(1)
	else:
		PlayerController.change_day(next_day)
	main_menu_scene.visible = true
	visible =  false
	grass_controller.current_pattern.queue_free()
	for pattern in grass_controller.patterns_left:
		pattern.queue_free()
	grass_controller.patterns_left.clear()
