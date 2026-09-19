class_name EnemyCardData
extends CardData

@export var mana_cost: int = 0
@export var stamina_cost: int = 0
@export var card_ability: EnemyCardAbility
## A formatted string using integer string identifiers to insert numbers onto the card where required. 
@export var ability_desc: String
## Store the base numbers for the card's ability here. Numbers should be stored in the order they appear.
@export var base_number_values: Dictionary
