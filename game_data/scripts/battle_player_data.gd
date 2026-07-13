class_name battle_player_data
extends RefCounted

var hit_points: int
var defense: Dictionary[String, int]
var max_stamina: int
var current_stamina: int
var max_mana: int
var current_mana: int
var mana_regen: int
var hand_size: int

var passive_status_effects: Dictionary[String, int]
var active_status_effects: Dictionary[String, active_status_effect]
