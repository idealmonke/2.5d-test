class_name BattlePlayerData
extends RefCounted

var base_max_health : int 
var max_health: int
var current_health: int 

var base_defense: Dictionary[COMMON_ENUMS.DAMAGE_TYPE, int]
var defense: Dictionary[COMMON_ENUMS.DAMAGE_TYPE, int]

var base_max_stamina: int 
var max_stamina: int 
var current_stamina: int 

var base_max_mana: int 
var max_mana: int 
var current_mana: int 

var base_mana_regen: int 
var mana_regen: int

var current_shield: int
var base_shield_retention: float 
var shield_retention: float 

var base_hand_size: int
var hand_size: int

var current_status_effects: Dictionary[String, StatusEffect]

var health_bar: TextureProgressBar
var health_label: Label

var mana_bar: TextureProgressBar
var mana_label: Label

var stamina_bar: TextureProgressBar
var stamina_label: Label

var status_effect_bar: StatusEffectDisplay
var shield_node: Node2D

func get_stamina() -> int:
	return current_stamina

func expend_stamina(stamina: int) -> int:
	current_stamina -= stamina
	if current_stamina < 0:
		current_stamina = 0
	_update_stat_bars()
	return current_stamina
	
func regen_stamina(stamina: int):
	current_stamina += stamina
	if current_stamina > max_stamina:
		current_stamina = max_stamina
	_update_stat_bars()
		
func _upkeep_regen_stamina() -> void:
	regen_stamina(max_stamina)
	_update_stat_bars()

func get_mana() -> int:
	return current_mana

func expend_mana(mana: int) -> int:
	current_mana -= mana
	if current_mana < 0:
		current_mana = 0
	_update_stat_bars()
	return current_mana

func regain_mana(mana: int) -> void:
	current_mana += mana
	if current_mana > max_mana:
		current_mana = max_mana
	_update_stat_bars()

func _upkeep_regen_mana() -> void:
	current_mana += mana_regen
	if current_mana > max_mana:
		current_mana = max_mana
	_update_stat_bars()

func take_damage(damage: Damage) -> void:
	if damage.source != null:
		damage.outgoing_update()
		
	damage.incoming_update(self.current_status_effects)
	
	if current_shield > 0 && !damage.ignore_shield:
		var variable = damage.damage_shield(current_shield, defense)
		current_shield -= variable
	current_health -= damage.damage_health(defense)
	
	if (damage.is_strike):
		_process_active_status(COMMON_ENUMS.TIMING.DAMAGED)
	
	_update_stat_bars()
	_update_status()
	
func add_status_stacks(status: StatusEffect, stacks: int, magnitude: float) -> void:
	if current_status_effects.has(status.data.name):
		var cur = current_status_effects.get(status.data.name)
		cur.stacks += stacks
		if cur.magnitude < magnitude:
			cur.magnitude = magnitude
	else:
		status.stacks = stacks
		status.magnitude = magnitude
		current_status_effects.set(status.data.name, status)
	self.update_passive_effects()
	_update_status()
	_update_stat_bars()

func _update_status():
	status_effect_bar.setup(192)
	status_effect_bar.reset(current_status_effects)

func gain_shield(shield : int) -> void:
	current_shield += shield
	_update_stat_bars()

func heal(healing: int) -> void:
	print(healing)
	
	current_health += healing
	if current_health > max_health:
		current_health = max_health
	_update_stat_bars()
	
func init_bars(hp_bar, hp_label, m_bar, m_label, s_bar, s_label, status_bars) -> void:
	health_bar = hp_bar
	health_label = hp_label
	health_bar.max_value = max_health
	
	mana_bar = m_bar
	mana_label = m_label
	mana_bar.max_value = max_mana
	
	stamina_bar = s_bar
	stamina_label = s_label
	stamina_bar.max_value = max_stamina
	
	status_effect_bar = status_bars
	
	_update_stat_bars()
	
func _update_stat_bars() -> void:
	
	health_bar.value = current_health
	health_label.text = str(current_health) + "/" + str(max_health)
	
	mana_bar.value = current_mana
	mana_label.text = str(current_mana) + "/" + str(max_mana)
	
	stamina_bar.value = current_stamina
	stamina_label.text = str(current_stamina) + "/" + str(max_stamina)
	
	health_bar.max_value = max_health
	stamina_bar.max_value = max_stamina
	mana_bar.max_value = max_mana
	
	if(shield_node):
		if(current_shield <= 0):
			shield_node.hide()
		else:
			shield_node.show()
			shield_node.get_node("shield_label").text = str(current_shield)

func process_statuses(timing: COMMON_ENUMS.TIMING) -> void:
	_process_active_status(timing)
	update_passive_effects()
	_process_status_stacks()
	_update_status()

func update_passive_effects() -> void:
	max_health = base_max_health
	max_mana = base_max_mana
	max_stamina = base_max_stamina
	mana_regen = base_mana_regen
	
	hand_size = base_hand_size
	defense = base_defense.duplicate()
	
	for effect_name in current_status_effects:
		var effect  : StatusEffect = current_status_effects[effect_name]
		var stat_calcs = effect.data.stats_calculations
		for stat in stat_calcs:
			var calc = stat_calcs[stat]
			
			if(stat==COMMON_ENUMS.PLAYER_STATS.HEALTH):
				max_health = calc.calculate.call(max_health)
			if(stat==COMMON_ENUMS.PLAYER_STATS.MANA):
				max_mana = calc.calculate.call(max_mana)
			if(stat==COMMON_ENUMS.PLAYER_STATS.STAMINA):
				max_stamina = calc.calculate.call(max_stamina)
			if(stat==COMMON_ENUMS.PLAYER_STATS.MANA_REGEN):
				mana_regen = calc.calculate.call(mana_regen)
			if(stat==COMMON_ENUMS.PLAYER_STATS.HANDSIZE):
				hand_size = calc.calculate.call(hand_size)
			if(stat==COMMON_ENUMS.PLAYER_STATS.DEFENSE):
				defense = calc.calculate.call(defense)

func _process_status_stacks():
	for key in current_status_effects.duplicate():
		var status: StatusEffect = current_status_effects.get(key)
		
		status.stacks -= 1
		status.duration_active += 1
		
		if status.stacks == 0:
			current_status_effects.erase(key)

func _process_active_status(timing: COMMON_ENUMS.TIMING) -> void:
	for key in current_status_effects:
		var status: StatusEffect = current_status_effects.get(key)
		if (status.data.abilities.has(timing)):
			status.data.abilities[timing].execute(self, status)
