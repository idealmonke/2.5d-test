class_name enemy_library
extends Node

var library: Array[enemy_card]

func _ready() -> void:
	pass

#func init(ids : Array[int]):
#	pass

func draw_card() -> enemy_card:
	if library.is_empty():
		return
	return library.pop_front()

func is_empty() -> bool:
	return library.is_empty()

func replenish_card(card: enemy_card) -> void:
	library.push_front(card)
	library.shuffle()

func replenish_cards(cards: Array[enemy_card]) -> void:
	library.append_array(cards)
	library.shuffle()
