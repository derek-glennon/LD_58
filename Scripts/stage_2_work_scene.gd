class_name StageTwoWorkController

extends Node2D

@export var main_menu_scene : Node
@export var food_order_generator : FoodOrderGenerator
@export var food_buttons : Array[FoodButton] = []
@export var order_text : RichTextLabel
@export var coin_scene : PackedScene
@export var instructions_text : RichTextLabel
@export var starting_phrases : Array[String] = []
@export var starting_delay := 3
@export var circle_timer : CircleTimer
@export var work_time_max := 30.0
@export var order_complete_delay := 2.0
@export var end_of_work_delay := 3.0
@export var celebration_phrases : Array[String] = []

var target_order : Order
var working_order : Order
var is_bell_active := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init() -> void:
	instructions_text.text = starting_phrases[PlayerController.day - 1]
	if PlayerController.day == 2:
		food_buttons[3].visible = true
	elif PlayerController.day == 3:
		food_buttons[3].visible = true
		food_buttons[4].visible = true
	var timer = get_tree().create_timer(starting_delay)
	timer.timeout.connect(_on_starting_delay_over)
	
	var line_1 = "Hamburgers: 0"
	var line_2 = "Fries: 0"
	var line_3 = "Drinks: 0"
	var line_4 = "Ice Cream: 0"
	var line_5 = "Cookies: 0"
	var final_line = line_1 + "\n\n" + line_2 + "\n\n" + line_3 + "\n\n" + line_4 + "\n\n" + line_5
	order_text.text = final_line

func _on_starting_delay_over() -> void:
	instructions_text.text  = ""
	circle_timer.start_timer(work_time_max)
	if !circle_timer.timer_finished.is_connected(_on_work_time_over):
		circle_timer.timer_finished.connect(_on_work_time_over)	
	for button in food_buttons:
		button.is_active = true
	is_bell_active = true
	_create_new_order()
	
func _on_order_complete_delay_over() -> void:
	for button in food_buttons:
		button.is_active = true
	is_bell_active = true
	_clear_food_items()
	_create_new_order()
	
func _clear_food_items() ->void:
	var nodes = HelperFunctions.get_all_children(self)
	for node in nodes:
		var food_item = node as FoodItem
		if food_item:
			food_item.queue_free()

func _create_new_order() -> void:
	working_order = Order.new()
	target_order = food_order_generator.generate_order()
	var line_1 = "Hamburgers: " + str(target_order.hamburgers)
	var line_2 = "Fries: " + str(target_order.fries)
	var line_3 = "Drinks: " + str(target_order.drinks)
	var line_4 = "Ice Cream: " + str(target_order.ice_creams)
	var line_5 = "Cookies: " + str(target_order.cookies)
	var final_line
	match PlayerController.day:
		1:
			final_line = line_1 + "\n\n" + line_2 + "\n\n" + line_3
		2:
			final_line = line_1 + "\n\n" + line_2 + "\n\n" + line_3 + "\n\n" + line_4
		3:
			final_line = line_1 + "\n\n" + line_2 + "\n\n" + line_3 + "\n\n" + line_4 + "\n\n" + line_5
	order_text.text = final_line
	
func _on_work_time_over() -> void:
	for button in food_buttons:
		button.is_active = false
	is_bell_active = false
	instructions_text.text = celebration_phrases.pick_random()
	var timer = get_tree().create_timer(end_of_work_delay)
	timer.timeout.connect(_on_end_of_work_delay_over)
	for i in range(30):
		await get_tree().create_timer(0.01).timeout
		_on_emit_coin(coin_scene.instantiate(), Vector2(960, 540), 0.5)
			
func _on_end_of_work_delay_over() -> void:
	instructions_text.text = ""
	PlayerController.change_current_scene(Enums.CurrentScene.MAIN)
	var next_day = PlayerController.day + 1
	if next_day > 3:
		PlayerController.change_stage(3)
		PlayerController.change_day(1)
	else:
		PlayerController.change_day(next_day)
	main_menu_scene.visible = true
	visible =  false
	_clear_food_items()
	
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

func _on_tray_area_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area and working_order:
		var food_item = area.get_parent() as FoodItem
		if food_item:
			match food_item.food_type:
				Enums.FoodTypes.HAMBURGER:
					working_order.hamburgers += 1
				Enums.FoodTypes.FRIES:
					working_order.fries += 1
				Enums.FoodTypes.DRINK:
					working_order.drinks += 1
				Enums.FoodTypes.ICECREAM:
					working_order.ice_creams += 1
				Enums.FoodTypes.COOKIE:
					working_order.cookies += 1


func _on_tray_area_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area and working_order:
		var food_item = area.get_parent() as FoodItem
		if food_item:
			if !food_item.collision_shape.disabled:
				match food_item.food_type:
					Enums.FoodTypes.HAMBURGER:
						working_order.hamburgers -= 1
					Enums.FoodTypes.FRIES:
						working_order.fries -= 1
					Enums.FoodTypes.DRINK:
						working_order.drinks -= 1
					Enums.FoodTypes.ICECREAM:
						working_order.ice_creams -= 1
					Enums.FoodTypes.COOKIE:
						working_order.cookies -= 1

func _on_bell_button_pressed() -> void:
	if working_order and is_bell_active:
		var order_done := false
		var equal_1 = working_order.hamburgers == target_order.hamburgers
		var equal_2 = working_order.fries == target_order.fries
		var equal_3 = working_order.drinks == target_order.drinks
		var equal_4 = working_order.ice_creams == target_order.ice_creams
		var equal_5 = working_order.cookies == target_order.cookies
		order_done = equal_1 and equal_2 and equal_3 and equal_4 and equal_5
		if order_done:
			working_order.hamburgers = 0
			working_order.fries = 0
			working_order.drinks = 0
			working_order.ice_creams = 0
			working_order.cookies = 0
			var nodes = HelperFunctions.get_all_children(self)
			for node in nodes:
				var food_item = node as FoodItem
				if food_item:
					food_item.collision_shape.disabled = true
			for button in food_buttons:
				button.is_active = false
			is_bell_active = false
			var timer = get_tree().create_timer(order_complete_delay)
			timer.timeout.connect(_on_order_complete_delay_over)
			for i in range(10):
				await get_tree().create_timer(0.01).timeout
				_on_emit_coin(coin_scene.instantiate(), Vector2(960, 540), 0.5)
			
