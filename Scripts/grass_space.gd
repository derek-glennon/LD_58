class_name GrassSpace

extends Node2D

@export var grass_sprite : Sprite2D
@export var grass_texture : Texture2D
@export var grass_mowed_texture : Texture2D
@export var collision_shape : CollisionShape2D

var mowed := false

@export var coin_scene : PackedScene
@export var coin_chance := 0.05
@export var coin_travel_time = 0.5

signal on_mowed
signal emit_coin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mowed = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	var mower := area.get_parent() as Mower
	if mower and mowed == false:
		mowed = true
		grass_sprite.texture = grass_mowed_texture
		collision_shape.set_deferred("disabled", true)
		on_mowed.emit()
		_maybe_emit_coin()
		
func _maybe_emit_coin():
	var rng = RandomNumberGenerator.new()
	var percent = rng.randf()
	var should_emit = percent < coin_chance
	if should_emit:
		emit_coin.emit(coin_scene.instantiate(), global_position, coin_travel_time)
