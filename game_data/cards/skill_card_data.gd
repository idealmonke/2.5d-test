class_name skill_card_data
extends card_data

enum TARGET_TYPE {none, single, double, triple, all}

@export var mana_cost: int = 0
@export var card_ability: skill_card_ability
@export var ability_desc: String
@export var card_classes: Array[String]
@export var target_type: TARGET_TYPE

## Store the base numbers for the card's ability here.
## Numbers should be stored in the order they appear.
@export var base_number_values: Array
