class_name CharacterData
extends Resource

@export var id: int
@export var art: Variant

@export var hp: int
@export var max_mana: int
@export var mana_regen: int
@export var stamina: int
@export var defense: Dictionary[COMMON_ENUMS.DAMAGE_TYPE, int]
@export var shield_retention: float

@export var main_class: COMMON_ENUMS.CHARACTER_CLASSES
@export var multi_class: COMMON_ENUMS.CHARACTER_CLASSES

@export var hand_size: int
@export var deck_slots: int
