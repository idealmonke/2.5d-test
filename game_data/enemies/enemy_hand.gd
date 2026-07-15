class_name enemy_hand
extends Node

var enemy_self: enemy
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

func replenish_card(card: enemy_card) -> void:
	library.replenish_card(card)
	hand.pop_at(hand.find(card))

func play_card():
	var valid_cards: Array[enemy_card] = hand.filter(func(card: enemy_card): return card.stamina_cost <= enemy_self.get_stamina())
	var card: enemy_card = valid_cards.pick_random()
	card.ability.call(controller)
