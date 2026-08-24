class_name battle_player_data
extends RefCounted

var max_hit_points: int = 40
var hit_points: int = 40
var defense: Dictionary[String, int]
var max_stamina: int = 10
var current_stamina: int = 10
var max_mana: int = 15
var current_mana: int = 15
var mana_regen: int
var hand_size: int = 2

var passive_status_effects: Dictionary[String, int]
var current_status_effects: Dictionary[String, status_effect_data]

var health_bar: TextureProgressBar
var health_label: Label

var mana_bar: TextureProgressBar
var mana_label: Label

var stamina_bar: TextureProgressBar
var stamina_label: Label

func get_stamina() -> int:
	return current_stamina

func expend_stamina(stamina: int) -> int:
	current_stamina -= stamina
	if current_stamina < 0:
		current_stamina = 0
	_update_bars()
	return current_stamina
	
func regen_stamina(stamina: int):
	current_stamina += stamina
	if current_stamina > max_stamina:
		current_stamina = max_stamina
	_update_bars()
		
func _upkeep_regen_stamina() -> void:
	regen_stamina(max_stamina)
	_update_bars()

func get_mana() -> int:
	return current_mana

func expend_mana(mana: int) -> int:
	current_mana -= mana
	if current_mana < 0:
		current_mana = 0
	_update_bars()
	return current_mana

func regain_mana(mana: int) -> void:
	current_mana += mana
	if current_mana > max_mana:
		current_mana = max_mana
	_update_bars()

func _upkeep_regen_mana() -> void:
	current_mana += mana_regen
	if current_mana > max_mana:
		current_mana = max_mana
	_update_bars()

func take_damage(type: COMMON_ENUMS.DAMAGE_TYPE, damage: int) -> void:
	if defense.has(type):
		damage -= defense.get(type)
		if damage < 0:
			damage = 0
	hit_points -= damage
	_update_bars()
	
func heal(healing: int) -> void:
	hit_points += healing
	if hit_points > max_hit_points:
		hit_points = max_hit_points
	_update_bars()
	
func init_bars(hp_bar, hp_label, m_bar, m_label, s_bar, s_label) -> void:
	health_bar = hp_bar
	health_label = hp_label
	health_bar.max_value = max_hit_points
	
	mana_bar = m_bar
	mana_label = m_label
	mana_bar.max_value = max_mana
	
	stamina_bar = s_bar
	stamina_label = s_label
	stamina_bar.max_value = max_stamina
	
	_update_bars()
	
func _update_bars() -> void:
	
	health_bar.value = hit_points
	health_label.text = str(hit_points) + "/" + str(max_hit_points)
	
	mana_bar.value = current_mana
	mana_label.text = str(current_mana) + "/" + str(max_mana)
	
	stamina_bar.value = current_stamina
	stamina_label.text = str(current_stamina) + "/" + str(max_stamina)

func initialize_player(party: Party) -> void:
	pass
