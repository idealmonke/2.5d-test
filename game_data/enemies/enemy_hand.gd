extends Node

var hand: Array[enemy_card]
var controller: battle_controller
var library: enemy_library

func _ready() -> void:
	pass
	
func draw_hand(hand_size: int) -> void:
	for i in hand_size:
		if library.is_empty():
			return
		hand.push_front(library.draw_card())
	
func replenish_hand() -> void:
	library.replenish_cards(hand)
	hand.clear()
