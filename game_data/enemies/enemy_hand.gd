class_name EnemyHand
extends Node

var enemy_self: Enemy
var hand: Array[EnemyCard]
var library: EnemyLibrary

@export var card_width: int = 200
@export var max_hand_width: int = 350
@export var arc_height: int = 50
@export var max_tilt_degrees: int = 15

func init(enem : Enemy, lib : Array[EnemyCard]) -> void:
	enemy_self = enem
	hand = []
	
	library = EnemyLibrary.new()
	library.library = lib

func draw_hand(hand_size: int) -> void:
	library.library.shuffle()
	
	for i in hand_size:
		if library.is_empty():
			return
		var card = library.draw_card()
		card.set_front()
		card.change_state(COMMON_ENUMS.ENEMY_CARD_STATE.HAND)
		hand.push_front(card)
	_set_hand_offset()
	for card in hand:
		card.change_state(COMMON_ENUMS.ENEMY_CARD_STATE.HAND)
	
func replenish_hand() -> void:
	for card in hand:
		card.set_back()
		card.change_state(COMMON_ENUMS.ENEMY_CARD_STATE.LIBRARY)
	library.replenish_cards(hand)
	hand.clear()

func replenish_card(card: EnemyCard) -> void:
	card.set_back()
	card.change_state(COMMON_ENUMS.ENEMY_CARD_STATE.LIBRARY)
	library.replenish_card(card)

func play_card() -> EnemyCard:
	var valid_cards: Array[EnemyCard] = hand.filter(func(card: EnemyCard): return card.stamina_cost <= enemy_self.get_stamina() && card.mana_cost <= enemy_self.get_mana())
	if valid_cards.is_empty():
		return null
	var card_to_play: EnemyCard = valid_cards.pick_random()
	
	hand.erase(card_to_play)
	
	enemy_self.expend_mana(card_to_play.mana_cost)
	enemy_self.expend_stamina(card_to_play.stamina_cost)
	
	card_to_play.change_state(COMMON_ENUMS.ENEMY_CARD_STATE.PLAYING)
	_set_hand_offset()
	
	card_to_play.ability.execute()
	
	return card_to_play

func play_hand() -> void:
	var done = false
	
	while not done:
		await BattleController.get_tree().create_timer(1.0).timeout
		var card = play_card()
		if(!card):
			done = true
			return
		
		await BattleController.get_tree().create_timer(1.0).timeout
		replenish_card(card)

func _set_hand_offset() -> void:
	var count = hand.size()
	
	if count == 0:
		return
	if count == 1:
		hand[0].location_offset = Vector2.ZERO
		hand[0].rotation_offset = 0.0
		return
		
	var ideal_total_width = (count - 1) * card_width # Distance apart if no overlap
	var spacing = card_width # Gap between card centers
	if ideal_total_width > max_hand_width:
		spacing = float(max_hand_width) / (count - 1)

	var total_width = spacing * (count - 1) # Actual width used
	var start_x = -total_width / 2.0 # Leftmost card x

	for index in range(count):
		var t = index / float(count - 1)  # Position as a fraction, 0 -> 1
		var centered_t = t - 0.5          # Normalized t, -0.5 to 0.5

		var x = start_x + spacing * index
		var y = arc_height * (centered_t * centered_t) * 3.0 - arc_height
		var tilt = deg_to_rad(max_tilt_degrees * centered_t * 1.2)

		hand[index].location_offset = Vector2(x, y)
		hand[index].rotation_offset = tilt
		hand[index].z_index = index
