class_name EnemyLibrary
extends Node

var library: Array[EnemyCard]

func draw_card() -> EnemyCard:
	if library.is_empty():
		return
	return library.pop_front()

func is_empty() -> bool:
	return library.is_empty()

func replenish_card(card: EnemyCard) -> void:
	library.push_front(card)
	library.shuffle()

func replenish_cards(cards: Array[EnemyCard]) -> void:
	library.append_array(cards)
	library.shuffle()
