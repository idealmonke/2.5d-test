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

#health related
func set_hitpoints(hp : int) -> void:
	hit_points = hp
func get_hitpoints() -> int:
	return hit_points
func take_damage_type(damage: int, type: String):
	#TODO: implement taking damage with defense values
	pass
func take_damage(damage : int) -> void:
	set_hitpoints(hit_points-damage);
func heal(health : int) -> void:
	set_hitpoints(hit_points+health)
 
#defense
func set_defense(type: String, d : int) -> void:
	defense[type] = d

#stamina
func set_max_stamina(stamina: int) -> void:
	max_stamina = stamina
func reset_stamina() -> void:
	current_stamina = max_stamina

#mana
func set_max_mana(mm: int) -> void:
	max_mana = mm
func set_mana_regen(mr: int) -> void:
	mana_regen = mr
func set_mana(m: int) -> void:
	current_mana = m
func regen_mana() -> void:
	change_mana(mana_regen)
func use_mana(mana_cost: int) -> bool:
	if(current_mana < mana_cost):
		return false
	change_mana(mana_cost)
	return true
func change_mana(mana_change: int) -> void:
	current_mana = clamp(current_mana+mana_change, 0, max_mana)

#hand size
func set_hand_size(size: int) -> void:
	hand_size = size
	
