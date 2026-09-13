class_name enemy_hand
extends Node

var enemy_self: enemy
var hand: Array[enemy_card]
var library: enemy_library

@export var card_width: int = 200
@export var max_hand_width: int = 550
@export var arc_height: int = 50

func _ready() -> void:
	pass

func init(enem : enemy, lib : Array[enemy_card]) -> void:
	enemy_self = enem
	hand = []
	
	library = enemy_library.new()
	library.library = lib

func draw_hand(hand_size: int) -> void:
	library.library.shuffle()
	
	for i in hand_size:
		if library.is_empty():
			return
		var card = library.draw_card()
		card.set_front()
		card.interactable_state = COMMON_ENUMS.ENEMY_CARD_STATE.HAND
		hand.push_front(card)
	_set_hand_offset()
	
func replenish_hand() -> void:
	for card in hand:
		card.set_back()
		card.interactable_state = COMMON_ENUMS.ENEMY_CARD_STATE.LIBRARY
	library.replenish_cards(hand)
	hand.clear()

func replenish_card(card: enemy_card) -> void:
	card.set_back()
	library.replenish_card(card)
	hand.pop_at(hand.find(card))

func play_card() -> enemy_card:
	var valid_cards: Array[enemy_card] = hand.filter(func(card: enemy_card): return card.stamina_cost <= enemy_self.get_stamina())
	if valid_cards.is_empty():
		return null
	var card: enemy_card = valid_cards.pick_random()
	#TODO: activate card
	return card

func play_hand() -> void:
	while play_card() != null:
		await get_tree().create_timer(1.0).timeout	

func _set_hand_offset() -> void:
	var count = hand.size()
	
	if count == 0:
		return
	if count == 1:
		hand[0].location_offset = Vector2.ZERO
		#hand[0].rotation_offset = 0.0
		return
		
	var ideal_total_width = (count - 1) * card_width # Distance apart if no overlap
	var spacing = card_width # Gap between card centers
	if ideal_total_width > max_hand_width:
		spacing = max_hand_width / (count - 1)

	var total_width = spacing * (count - 1) # Actual width used
	var start_x = -total_width / 2.0 # Leftmost card x

	for index in range(count):
		var x = start_x + spacing * index

		hand[index].location_offset = Vector2(x, 0)
		hand[index].z_index = index
		#hand[index].old_z_index = index
