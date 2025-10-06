extends Node
	
# Get All Children recursive
func get_all_children(in_node,arr:=[]):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return arr
	
func sort_cards_by_number(a, b):
	var cardA := a as Card
	var cardB := b as Card
	if cardA.card_number < cardB.card_number:
		return true
	return false
