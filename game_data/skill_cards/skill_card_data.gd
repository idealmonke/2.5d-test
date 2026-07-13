class_name skill_card_data
extends card_data

@export var mana_cost: int = 0
@export var stamina_cost: int = 0
@export var card_ability: skill_card_ability
## A formatted string using integer string identifiers to insert numbers onto the card where required. 
@export var ability_desc: String
## An Array containing either one or two classes. 
@export var card_classes: Array[String]
@export var target_type: COMMON_ENUMS.TARGET_TYPE
## Store the base numbers for the card's ability here. Numbers should be stored in the order they appear.
@export var base_number_values: Dictionary
