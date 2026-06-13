class_name battle_controller
extends Node

var data: battle_data

# Lambda Functions for game events, modified by perks
var current_draw_card: Callable
var current_discard_card: Callable

# Init Battle Controller
func _ready() -> void:
	current_draw_card = draw_card
	current_discard_card = discard_card


# Immutable Game Actions (These are what we call elsewhere)
func replenish_single() -> void:
	
	pass
	
func replenish_discard() -> void:
	pass

func draw_card() -> void:
	# Some Stuff
	current_draw_card.call()
	# Some More Stuff
	pass
	
func discard_card() -> void:
	# Some Stuff
	current_discard_card.call()
	# Some More Stuff
	pass

# Mutable Game Actions (Default lambda functions, sometimes replaced by perks)
func default_draw_card() -> void:
	var card = data.library.pop_top_card()
	data.hand.add_card(card)

func default_discard_card(card: skill_card) -> void:
	data.hand.discard_card(card)

# Helper Functions for Abilities
func get_player_damage_modifier() -> float:
	return 0

func get_player_damage_resistance() -> float:
	return 0

# Main Loop
