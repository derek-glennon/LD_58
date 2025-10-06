class_name GrassController

extends Node2D

@export var spawn_delay = 0.5
@export var coin_scene : PackedScene
@export var rock_scene : PackedScene
@export var number_rocks_day_two_min := 1
@export var number_rocks_day_two_max := 3
@export var number_rocks_day_three_min := 2
@export var number_rocks_day_three_max := 5
@export var grass_pattern_spawn_point : Node
@export var grass_paterns_day_one: Array[PackedScene] = []
@export var grass_paterns_day_two: Array[PackedScene] = []
@export var grass_paterns_day_three: Array[PackedScene] = []

var patterns_left: Array[GrassPattern] = []
var current_pattern: GrassPattern

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init() -> void:
	_populate_patterns_list()
	_spawn_new_pattern()
				
func _populate_patterns_list() -> void:
	match PlayerController.day:
		1:
			for scene in grass_paterns_day_one:
				var pattern = scene.instantiate() as GrassPattern
				pattern.all_mowed.connect(_on_pattern_mowed)
				patterns_left.append(pattern)
		2:
			for scene in grass_paterns_day_two:
				var pattern = scene.instantiate() as GrassPattern
				pattern.all_mowed.connect(_on_pattern_mowed)
				patterns_left.append(pattern)
		3:
			for scene in grass_paterns_day_three:
				var pattern = scene.instantiate() as GrassPattern
				pattern.all_mowed.connect(_on_pattern_mowed)
				patterns_left.append(pattern)
	
func _spawn_new_pattern() -> void:
	var new_pattern = patterns_left.pick_random()
	grass_pattern_spawn_point.add_child(new_pattern)
	patterns_left.erase(new_pattern)
	
	#reset the array if we get through all of the patterns
	if patterns_left.size() == 0:
		_populate_patterns_list()
		
	# Connect for Coin spawning
	new_pattern.init()
	for grass in new_pattern.grass_spaces:
		var grass_space = grass as GrassSpace
		if grass_space:
			grass_space.emit_coin.connect(_on_emit_coin)
	
	# Spawn Rocks
	var rng = RandomNumberGenerator.new()
	var rock_amount := 0
	if PlayerController.day == 2:
		rock_amount = rng.randi_range(number_rocks_day_two_min, number_rocks_day_two_max)
	elif PlayerController.day == 3:
		rock_amount = rng.randi_range(number_rocks_day_three_min, number_rocks_day_three_max)
	if rock_amount > 0:
		for i in range(rock_amount):
			var grass_to_cover = new_pattern.grass_spaces.pick_random()
			var rock = rock_scene.instantiate()
			new_pattern.add_child(rock)
			rock.global_position = grass_to_cover.global_position
			new_pattern.grass_spaces.erase(grass_to_cover)
			grass_to_cover.queue_free()
		new_pattern.max_mowed -= rock_amount
		
	for grass in new_pattern.grass_spaces:
		var grass_space := grass as GrassSpace
		if grass_space:
			grass_space.collision_shape.set_deferred("disabled", false)
		
	current_pattern = new_pattern
	
func _on_pattern_mowed() -> void:
	var timer  = get_tree().create_timer(spawn_delay)
	timer.timeout.connect(_on_spawn_delay)
	match PlayerController.day:
		1:
			_on_emit_coin(coin_scene.instantiate(), Vector2(960, 540), 0.5)
		2:
			for i in range(2):
				await get_tree().create_timer(0.1).timeout
				_on_emit_coin(coin_scene.instantiate(), Vector2(960, 540), 0.5)
		3:
			for i in range(3):
				await get_tree().create_timer(0.1).timeout
				_on_emit_coin(coin_scene.instantiate(), Vector2(960, 540), 0.5)
				
	
func _on_spawn_delay() -> void:
	current_pattern.queue_free()
	_spawn_new_pattern()
	
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
