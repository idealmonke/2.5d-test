class_name skill_card_discard
extends Node

var discard: Array[skill_card] = []
	
func get_size() -> int:
	return discard.size()

func pop_front_card() -> skill_card:
	return discard.pop_front()

func pop_card(card: skill_card) -> skill_card:
	var index := discard.find(card)
	if index == -1:
		return null
	return discard.pop_at(index)

func add_card(card: skill_card) -> void:
	discard.push_front(card)

func is_empty() -> bool:
	return discard.is_empty()
