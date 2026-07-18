class_name battle_controller
extends Node

var data: battle_data

# Lambda Functions for game events, modified by perks
var current_draw_card: Callable
var current_discard_card: Callable

## Helps cards 
var global_state: COMMON_ENUMS.GLOBAL_CARD_STATE = COMMON_ENUMS.GLOBAL_CARD_STATE.PLAYING

# Init Battle Controller
func _ready() -> void:
	data = battle_data.new()
	data.player = battle_player_data.new()
	
	data.discard = $discard
	data.library = $library
	data.hand = $hand
	
	current_draw_card = _default_draw_card
	current_discard_card = _default_discard_card
	
	# TEMPORARY TESTING CODE
	data.library.push_to_top($card_storage/skill_card)
	data.library.push_to_top($card_storage/skill_card2)
	data.library.push_to_top($card_storage/skill_card3)
	data.library.push_to_top($card_storage/skill_card4)
	data.library.push_to_top($card_storage/skill_card5)
	$card_storage/skill_card/card_name.text = "Gooby"
	$card_storage/skill_card2/card_name.text = "Chungus"
	$card_storage/skill_card3/card_name.text = "Bingus"
	$card_storage/skill_card4/card_name.text = "Wakka Wakka"
	$card_storage/skill_card5/card_name.text = "Looney"
	for card in data.library.library:
		card.set_back()
	# TEMPORARY TESTING CODE
	
# Main Loop
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_Q:
			draw_card()
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_W:
			dredge_card()
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_E:
			replenish_discard()
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_R:
			discard_front()
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_P:
			for enem in data.enemies:
				enem.process_turn()

# Immutable Game Actions (These are what we call elsewhere)
func draw_card() -> void:
	if data.library.is_empty():
		return
	# Some Stuff
	current_draw_card.call()
	# Some More Stuff
	
func discard_card(card: skill_card) -> void:
	# Some Stuff
	current_discard_card.call(card)
	# Some More Stuff
	
func dredge_card() -> void:
	var card = data.library.pop_top_card()
	if card == null:
		return
	data.discard.add_card(card)
	card.interactable_state = COMMON_ENUMS.INTERACT_STATE.DISCARD
	card.set_front()

func replenish_discard() -> void:
	while data.discard.is_empty() == false:
		var card = data.discard.pop_front_card()
		data.library.push_to_top(card)
		card.interactable_state = COMMON_ENUMS.INTERACT_STATE.LIBRARY
		card.set_back()
	data.library.shuffle()
	
func replenish_single(card: skill_card) -> void:
	var temp = data.discard.pop_card(card)
	if temp == null:
		return
	data.library.push_to_top(temp)
	temp.interactable_state = COMMON_ENUMS.INTERACT_STATE.LIBRARY
	temp.set_back()
	data.library.shuffle()
	
func discard_front() -> void:
	var temp = data.hand.pop_front()
	if temp == null:
		return
	data.discard.add_card(temp)
	temp.interactable_state = COMMON_ENUMS.INTERACT_STATE.DISCARD

# Mutable Game Actions (Default lambda functions, sometimes replaced by perks)
func _default_draw_card() -> void:
	var card = data.library.pop_top_card()
	if card == null:
		return
	data.hand.add_card(card)
	card.interactable_state = COMMON_ENUMS.INTERACT_STATE.HAND
	card.set_front()

func _default_discard_card(card: skill_card) -> void:
	data.hand.pop_card(card)
	data.discard.add_card(card)
	card.interactable_state = COMMON_ENUMS.INTERACT_STATE.DISCARD

func _process_active_status(timing: COMMON_ENUMS.TIMING) -> void:
	for key in data.player.active_status_effects:
		if data.player.active_status_effects.has(key) && data.player.active_status_effects.get(key).timing == timing:
			data.player.active_status_effects.get(key).execute(self)
			data.player.active_status_effects.get(key).stacks -= 1
			if data.player.active_status_effects.get(key).stacks == 0:
				data.player.active_status_effects.erase(key)

func _player_upkeep() -> COMMON_ENUMS.BATTLE_STATE:
	data.player._upkeep_regen_mana()
	data.player._upkeep_regen_stamina()
	
	var current_handsize = data.player.hand_size
	for i in range(current_handsize):
		draw_card()

	_process_active_status(COMMON_ENUMS.TIMING.START)
	return COMMON_ENUMS.BATTLE_STATE.PLAYER_PLAYING

func _player_endstep() -> COMMON_ENUMS.BATTLE_STATE:
	var old_cards: Array[skill_card] = data.hand.pop_each()
	old_cards.append_array(data.discard.pop_exhausted())
	
	for card in old_cards:
		card.interactable_state = COMMON_ENUMS.INTERACT_STATE.LIBRARY
		card.exhausted = false
		card.set_back()
	data.library.push_each(old_cards)
	return COMMON_ENUMS.BATTLE_STATE.ENEMY_TURNS
