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

func get_stamina() -> int:
	return current_stamina

func expend_stamina(stamina: int) -> int:
	current_stamina -= stamina
	if current_stamina < 0:
		current_stamina = 0
	return current_stamina
	
func regen_stamina(stamina: int):
	current_stamina += stamina
	if current_stamina > max_stamina:
		current_stamina = max_stamina
		
func _upkeep_regen_stamina() -> void:
	regen_stamina(max_stamina)

func get_mana() -> int:
	return current_mana

func expend_mana(mana: int) -> int:
	current_mana -= mana
	if current_mana < 0:
		current_mana = 0
	return current_mana

func regain_mana() -> void:
	current_mana += mana_regen
	if current_mana > max_mana:
		current_mana = max_mana

func _upkeep_regen_mana() -> void:
	current_mana += mana_regen
	if current_mana > max_mana:
		current_mana = max_mana

func take_damage(type: COMMON_ENUMS.DAMAGE_TYPE, damage: int) -> void:
	if defense.has(type):
		damage -= defense.get(type)
		if damage < 0:
			damage = 0
	hit_points -= damage

func initialize_player(party: Party) -> void:
	pass
