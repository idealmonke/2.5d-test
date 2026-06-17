class_name battle_controller
extends Node

var data: battle_data

# Lambda Functions for game events, modified by perks
var current_draw_card: Callable
var current_discard_card: Callable

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

func replenish_discard() -> void:
	while data.discard.is_empty() == false:
		var card = data.discard.pop_front_card()
		data.library.push_to_top(card)
		card.interactable_state = COMMON_ENUMS.INTERACT_STATE.LIBRARY
	data.library.shuffle()
	
func replenish_single(card: skill_card) -> void:
	var temp = data.discard.pop_card(card)
	if temp == null:
		return
	data.library.push_to_top(temp)
	temp.interactable_state = COMMON_ENUMS.INTERACT_STATE.LIBRARY
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

func _default_discard_card(card: skill_card) -> void:
	data.hand.pop_card(card)
	data.discard.add_card(card)
	card.interactable_state = COMMON_ENUMS.INTERACT_STATE.DISCARD

# Helper Functions for Abilities
func _get_player_damage_modifier() -> float:
	return 0

func _get_player_damage_resistance() -> float:
	return 0
