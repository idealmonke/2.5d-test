class_name skill_card_library
extends Node2D

var library: Array[skill_card] = []
var shuffle_func: Callable

func _ready() -> void:
	shuffle_func = _unweighted_shuffle

func load_cards_from_party(party: Party) -> void:
	for i in range(party.card_ids):
		var data := skill_card_registry.get_card_data(party.card_ids[i])
		var card := skill_card.new()
		card.initialize_card(data)
		library.append(card)
	self.shuffle()
	
func get_size() -> int:
	return library.size()

func pop_top_card() -> skill_card:
	if library.is_empty():
		return null
	return	library.pop_front()

func shuffle() -> void:
	shuffle_func.call()
	
func push_to_top(card: skill_card) -> void:
	library.push_front(card)

func is_empty() -> bool:
	return library.is_empty()

func _unweighted_shuffle() -> void:
	library.shuffle()
	
