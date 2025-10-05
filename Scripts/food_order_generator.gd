class_name FoodOrderGenerator

extends Node2D

@export var hamburger_min := 0
@export var hamburger_max := 2
@export var fries_min := 0
@export var fries_max := 3
@export var drink_min := 1
@export var drink_max := 2
@export var ice_cream_min := 0
@export var ice_cream_max := 4
@export var cookie_min := 0
@export var cookie_max := 3

func generate_order() -> Order:
	var order = Order.new()
	var rng = RandomNumberGenerator.new()
	order.hamburgers = rng.randi_range(hamburger_min, hamburger_max)
	order.fries = rng.randi_range(fries_min, fries_max)
	order.drinks = rng.randi_range(drink_min, drink_max)
	if PlayerController.day >= 2:
		order.ice_creams = rng.randi_range(ice_cream_min, ice_cream_max)
		if PlayerController.day >= 3:
			order.cookies = rng.randi_range(cookie_min, cookie_max)
	return order
