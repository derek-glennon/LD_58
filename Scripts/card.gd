class_name Card

extends TextureRect

@export var card_title := "Sample Name"
@export var card_description := "This is some sample card text"
@export var card_number := -1
@export var cost := 0
@export var rarity := Enums.Rarity.COMMON
@export var card_title_text : RichTextLabel
@export var card_description_text : RichTextLabel
@export var card_number_text : RichTextLabel
@export var card_rarity_text : RichTextLabel
@export var uncommon_color : Color
@export var rare_color : Color
@export var ultrarare_color : Color
@export var mystery_card : Button
@export var buy_single_button : Button
@export var cost_text : RichTextLabel
@export var collection_from_pack_duration := 1.0
@export var sell_from_pack_duration := 0.5
@export var reveal_mystery_card_duration := 1.0
@export var bounce_card_duration := 0.5
@export var bounce_card_curve : Curve
@export var new_texture_bounce : Curve
@export var new_texture_bounce_delay := 0.5
@export var new_texture : TextureRect
@export var coin_scene : PackedScene
@export var explosion_scene : PackedScene
@export var rare_explosion_scene : PackedScene
@export var ultrarare_explosion_scene : PackedScene

var is_unlocked := false
var money_ui
var collection_button_position := Vector2(0,0)
var reveal_animation_ongoing := false
var coins_collected := 0

signal card_pack_animation_done

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_title_text.text = card_title
	card_description_text.text = card_description
	card_number_text.text = str(card_number)
	cost_text.text = str(cost) + " - Buy"
	match rarity:
		Enums.Rarity.COMMON:
			card_rarity_text.text = "C"
			card_rarity_text.add_theme_color_override("default_color", Color.WHITE)
		Enums.Rarity.UNCOMMON:
			card_rarity_text.text = "U"
			card_rarity_text.add_theme_color_override("default_color", uncommon_color)
		Enums.Rarity.RARE:
			card_rarity_text.text = "R"
			card_rarity_text.add_theme_color_override("default_color", rare_color)
		Enums.Rarity.ULTRARARE:
			card_rarity_text.text = "UR"
			card_rarity_text.add_theme_color_override("default_color", ultrarare_color)
	
	# Setup connections
	money_ui = PlayerController.money_ui
	
func on_unlock() -> void:
	is_unlocked = true	
	buy_single_button.visible = false
	
func clone_card(card: Card) -> void:
	self.texture = card.texture
	card_title = card.card_title
	card_title_text.text = card.card_title
	card_description = card.card_description
	card_description_text.text = card.card_description
	card_number = card.card_number
	card_number_text.text = str(card.card_number)
	rarity = card.rarity
	match rarity:
		Enums.Rarity.COMMON:
			card_rarity_text.text = "C"
			card_rarity_text.add_theme_color_override("default_color", Color.WHITE)
		Enums.Rarity.UNCOMMON:
			card_rarity_text.text = "U"
			card_rarity_text.add_theme_color_override("default_color", uncommon_color)
		Enums.Rarity.RARE:
			card_rarity_text.text = "R"
			card_rarity_text.add_theme_color_override("default_color", rare_color)
		Enums.Rarity.ULTRARARE:
			card_rarity_text.text = "UR"
			card_rarity_text.add_theme_color_override("default_color", ultrarare_color)
	is_unlocked = card.is_unlocked
	if !PlayerController.is_opening_pack:
		mystery_card.visible = !is_unlocked
	cost = card.cost
	cost_text.text = str(card.cost) + " - Buy"
	if PlayerController.current_scene == Enums.CurrentScene.BUY and !PlayerController.is_opening_pack:
		buy_single_button.visible = !card.is_unlocked

func _on_buy_single_button_pressed() -> void:
	if PlayerController.money >= cost:
		PlayerController.change_money(PlayerController.money - cost)
		var card_to_unlock = PlayerController.find_card_by_number(card_number)
		if card_to_unlock:
			PlayerController.unlock_card(card_to_unlock)

func _on_mystery_card_pressed() -> void:
	if !reveal_animation_ongoing:
		if mystery_card.self_modulate.a != 0:
			#play reveal animation
			reveal_animation_ongoing = true
			
			var is_new := false
			var card = PlayerController.find_card_by_number(card_number)
			var index = PlayerController.unlocked_cards.find(card)
			if index == -1:
				is_new = true
				new_texture.visible = true
				new_texture.scale = Vector2(0.0, 0.0)
			
			var tween = get_tree().create_tween()
			tween.set_parallel(true)
			tween.tween_property(mystery_card, "self_modulate:a", 0.0, reveal_mystery_card_duration)
			tween.tween_callback(_spawn_explosion).set_delay(reveal_mystery_card_duration - 0.3)
			tween.tween_method(_bounce_curve, 0.0, 1.0, bounce_card_duration).set_delay(reveal_mystery_card_duration)
			if is_new:
				tween.tween_method(_new_texture_bounce, 0.0, 1.0, bounce_card_duration).set_delay(reveal_mystery_card_duration + new_texture_bounce_delay)
			tween.tween_callback(_on_reveal_animation_done).set_delay(reveal_mystery_card_duration + bounce_card_duration + new_texture_bounce_delay)
		else:
			mystery_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
			#play collect/sell animation
			var card = PlayerController.find_card_by_number(card_number)
			var index = PlayerController.unlocked_cards.find(card)
			if index == -1:
				PlayerController.unlock_card(card)
				play_collect_animation()
			else:
				play_sell_animation()
				
				
func _spawn_explosion():
	var explosion = null
	match rarity:
		Enums.Rarity.UNCOMMON:
			explosion = explosion_scene.instantiate() as Explosion
		Enums.Rarity.RARE:
			explosion = rare_explosion_scene.instantiate() as Explosion
		Enums.Rarity.ULTRARARE:
			explosion = ultrarare_explosion_scene.instantiate() as Explosion
		
	if explosion != null: 
		get_tree().root.add_child(explosion)
		explosion.global_position = Vector2(960.0, 540.0)
		explosion.explode()

func _bounce_curve(progress):
	var new_scale = bounce_card_curve.sample(progress)
	scale = Vector2(new_scale, new_scale)
	
func _new_texture_bounce(progress):
	var new_scale = bounce_card_curve.sample(progress)
	new_texture.scale = Vector2(new_scale, new_scale)
	
func _on_reveal_animation_done() -> void:
	reveal_animation_ongoing = false
			
func play_collect_animation() -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", collection_button_position, collection_from_pack_duration)
	tween.tween_property(self, "scale", Vector2(0.0, 0.0), collection_from_pack_duration)
	tween.tween_callback(_on_collect_animation_done).set_delay(collection_from_pack_duration)

func _on_collect_animation_done() -> void:
	card_pack_animation_done.emit()
	queue_free()
	
func play_sell_animation() -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2(0.0, 0.0), sell_from_pack_duration)
	tween.tween_callback(_on_sell_animation_done).set_delay(sell_from_pack_duration)

func _on_sell_animation_done() -> void:
	coins_collected = 0
	var sell_cost = int(floor((cost * 0.25)))
	if sell_cost == 0:
		sell_cost = 1
		
	for i in range(sell_cost):
			await get_tree().create_timer(0.01).timeout
			_on_emit_coin(coin_scene.instantiate(), Vector2(960, 540), 0.5)
			
func _on_emit_coin(coin : Node, start_position : Vector2, duration : float) -> void:
	get_tree().root.add_child(coin)
	coin.global_position = start_position
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(coin, "position", PlayerController.money_ui.position, duration)
	tween.tween_property(coin, "scale", Vector2(0.2, 0.2), duration)
	tween.tween_callback(coin.queue_free).set_delay(duration)
	var timer = get_tree().create_timer(duration)
	timer.timeout.connect(_on_coin_collected)
	
func _on_coin_collected() -> void:
	PlayerController.change_money(PlayerController.money + 1)
	coins_collected += 1
	
	var sell_cost = int(floor((cost * 0.25)))
	if sell_cost == 0:
		sell_cost = 1
		
	if coins_collected == sell_cost:
		card_pack_animation_done.emit()
		queue_free()
	
