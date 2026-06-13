class_name skill_card_library
extends Node

var library: Array[skill_card] = []

func load_cards_from_party(party: Party) -> void:
	for i in range(party.card_ids):
		var data = skill_card_registry.get_card_data(party.card_ids[i])
		library.append(skill_card.new())
	library.shuffle()
	
func get_size() -> int:
	return library.size()

func pop_top_card() -> skill_card:
	return	library.pop_front()

func shuffle() -> void:
	library.shuffle()
