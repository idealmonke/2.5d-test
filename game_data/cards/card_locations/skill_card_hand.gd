class_name skill_card_hand
extends Node

var hand: Array[skill_card]

func add_card(card: skill_card) -> void:
	hand.append(card)

func get_hand_size() -> int:
	return hand.size()

func pop_card(card: skill_card) -> skill_card:
	var index := hand.find(card)
	if index == -1:
		return null
	return hand.pop_at(index)
	
func pop_each() -> Array:
	var old_hand := hand.duplicate()
	hand.clear()
	return old_hand

func is_empty() -> bool:
	return hand.is_empty()
