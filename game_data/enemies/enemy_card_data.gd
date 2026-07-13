class_name enemy_card_data
extends card_data

@export var mana_cost: int = 0
@export var stamina_cost: int = 0
@export var card_ability: enemy_card_ability
## A formatted string using integer string identifiers to insert numbers onto the card where required. 
@export var ability_desc: String
## Store the base numbers for the card's ability here. Numbers should be stored in the order they appear.
@export var base_number_values: Dictionary
