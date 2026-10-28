class_name SkillCardData
extends CardData

@export var mana_cost: int = 0
@export var stamina_cost: int = 0
@export var card_ability: SkillCardAbility
## A formatted string using integer string identifiers to insert numbers onto the card where required. 
@export var ability_desc: String
## An Array containing either one or two classes. 
@export var card_classes: Array[COMMON_ENUMS.CHARACTER_CLASSES]
@export var target_type: COMMON_ENUMS.TARGET_TYPE
@export var flag: COMMON_ENUMS.TARGET_FLAG
@export var discard_castable: COMMON_ENUMS.DISCARD_CASTABLE_MODES = COMMON_ENUMS.DISCARD_CASTABLE_MODES.NONE

## Store the base numbers for the card's ability here. Numbers should be stored in the order they appear.
@export var base_number_values: Dictionary
