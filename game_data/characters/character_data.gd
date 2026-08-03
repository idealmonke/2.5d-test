class_name character_data
extends Resource

@export var id: int
@export var hp: int
@export var max_mana: int
@export var mana_regen: int
@export var stamina: int
@export var defense: Dictionary

@export var main_class: String

# Use a string "None" for single classed characters for now, we might set a better convention later
@export var multi_class: String

@export var hand_size: int
@export var deck_slots: int
