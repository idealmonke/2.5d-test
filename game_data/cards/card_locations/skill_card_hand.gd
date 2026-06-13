class_name skill_card_hand
extends Node

var hand: Array[skill_card]

func add_card(card: skill_card) -> void:
	hand.append(card)
	
func discard_card(card: skill_card) -> void:
	pass

func get_hand_size() -> int:
	return hand.size()

func pop_position(pos: int):
	return hand.pop_at(pos)

func pop_each() -> Array:
	var old_hand: Array
	for i in range(hand):
		hand.pop_front()
	return old_hand
