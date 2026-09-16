class_name enemy
extends Area2D

var controller: battle_controller

# cur idx
var idx : int

# Size of Texture
const ENEMY_SPRITE_SIZE = 200

# Locations
var hand: enemy_hand
var library: enemy_library

# Enemy Stats
var base_max_health: int
var max_health: int
var current_health: int
var defense: Dictionary[COMMON_ENUMS.DAMAGE_TYPE, int]
var current_shield: int
var shield_retention: int
var base_shield_retention: int

# immutable stats
var enemy_name : String

var base_max_stamina: int
var base_max_mana: int
var base_mana_regen: int
var base_hand_size: int

var hand_size: int
var max_stamina: int
var current_stamina: int
var max_mana: int
var current_mana: int
var mana_regen: int

var current_status_effects: Dictionary[String, status_effect]

# Child Nodes for UI control
var sprite: Sprite2D
var collision: CollisionShape2D
var health_bar: TextureProgressBar
var stamina_bar: TextureProgressBar
var mana_bar: TextureProgressBar

var enemy_card_container : Node2D

var health_bar_text : Label
var stamina_bar_text : Label
var mana_bar_text : Label

var status_effect_bar : status_effect_display

# Card Arts
var base_sprite: Texture2D

func _ready() -> void:
	max_mana = base_max_mana
	max_stamina = base_max_stamina
	mana_regen = base_mana_regen
	
	sprite = $Sprite2D
	collision = $CollisionShape2D
	health_bar = $health_bar
	stamina_bar = $stamina_bar
	mana_bar = $mana_bar
	
	health_bar_text = $health_bar_text
	stamina_bar_text = $stamina_bar_text
	mana_bar_text = $mana_bar_text
	
	enemy_card_container = $enemy_card_container
	
	status_effect_bar = $status_effect_bar

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

func get_mana() -> int:
	return current_mana

func expend_mana(mana: int) -> int:
	current_mana -= mana
	if current_mana < 0:
		current_mana = 0
	_update_stat_bars()
	return current_mana

func regain_mana() -> void:
	current_mana += mana_regen
	if current_mana > max_mana:
		current_mana = max_mana
	_update_stat_bars()

func _upkeep_regen_mana() -> void:
	print(str(current_mana) +" "+str(mana_regen))
	current_mana += mana_regen
	if current_mana > max_mana:
		current_mana = max_mana
	_update_stat_bars()
	
func update_passive_effects() -> void:
	max_health = base_max_health
	max_mana = base_max_mana
	max_stamina = base_max_stamina
	mana_regen = base_mana_regen
	
	for effect_name in current_status_effects:
		var effect  : status_effect = current_status_effects[effect_name]
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

func take_damage(damage: Damage) -> void:
	
	if damage.source != null:
		damage.outgoing_update()
		
	damage.incoming_update(self.current_status_effects)
	
	for key in current_status_effects:
		var status: status_effect = current_status_effects.get(key)
		if status.data.stats_calculations.has(COMMON_ENUMS.PLAYER_STATS.OUTGOING_DAMAGE):
			damage.modify_all_damage(status.data.stats_calculations[COMMON_ENUMS.PLAYER_STATS.OUTGOING_DAMAGE].calculate)
	
	if current_shield > 0:
		current_shield -= damage.damage_shield(current_shield, defense)
	current_health -= damage.damage_health(defense)
	
	if (damage.is_strike):
		_process_active_status(COMMON_ENUMS.TIMING.DAMAGED)
	
	_update_stat_bars()

func is_dead() -> bool:
	return current_health<=0
	
func add_status_stacks(status: status_effect, stacks: int, magnitude: float) -> void:
	if current_status_effects.has(status.data.name):
		var cur = current_status_effects.get(status.data.name)
		cur.stacks += stacks
		if cur.magnitude < magnitude:
			cur.magnitude = magnitude
	else:
		status.stacks = stacks
		status.magnitude = magnitude
		current_status_effects.set(status.data.name, status)
	_update_status()

func _update_status():
	status_effect_bar.setup(192)
	status_effect_bar.reset(current_status_effects)

func _process_active_status(timing: COMMON_ENUMS.TIMING) -> void:
	for key in current_status_effects:
		var status: status_effect = current_status_effects.get(key)
		if (status.data.abilities.has(timing)):
			status.stacks -= 1
			status.duration_active += 1
			status.data.abilities[timing].execute(self, status)
			if status.stacks == 0:
				current_status_effects.erase(key)
	_update_status()

func _update_stat_bars() -> void:
	health_bar.value = float(current_health) / max_health * 100
	stamina_bar.value = float(current_stamina) / max_stamina * 100
	mana_bar.value = float(current_mana) / max_mana * 100
	
	health_bar_text.text = str(current_health)+"/"+str(max_health)
	stamina_bar_text.text = str(current_stamina)+"/"+str(max_stamina)
	mana_bar_text.text = str(current_mana)+"/"+str(max_mana)
	
	
func initialize_data(data: enemy_data, cur_idx : int) -> void:
	enemy_name = data.enemy_name
	idx = cur_idx
	
	base_max_health = data.max_health
	base_max_stamina = data.max_stamina
	base_max_mana = data.max_mana
	max_health = data.max_health
	max_stamina = data.max_stamina
	max_mana = data.max_mana
	
	mana_regen = data.mana_regen
	
	current_health = max_health
	current_mana = max_mana
	current_stamina = max_stamina
	
	base_hand_size = data.hand_size
	hand_size = data.hand_size
	
	#base_shield_retention = data.shield_retention
	#shield_retention = data.shield_retention
	
	_update_stat_bars()
	
	base_sprite = data.art
	sprite.texture = base_sprite
	
	#TODO: make image scaling / position automatic
	var TEMP_SIZE = 400
	
	if(data.enemy_name=="goku"):
		TEMP_SIZE = 200
		sprite.position.y -= 100
	
	sprite.scale = Vector2(TEMP_SIZE,TEMP_SIZE) / base_sprite.get_size()
	
	#activate_goku_mode(data.card_ids)

#func activate_goku_mode(ids : Array[int]):
#	library = enemy_library.new()
#	library.init(ids)

func setup_library(lib : Array[enemy_card]) -> void:
	hand = enemy_hand.new()
	hand.init(self, lib)

func process_turn() -> void:
	BattleController.active_turn = self
	
	# Upkeep
	_upkeep_regen_mana()
	_upkeep_regen_stamina()
	_process_active_status(COMMON_ENUMS.TIMING.START)
	
	if(current_health<=0):
		return
	
	# Playing Turn
	
	#TODO: set hand size
	
	print("processing turn for enemy # "+str(idx))
	
	hand.draw_hand(hand_size)
	
	await hand.play_hand()
	
	hand.replenish_hand()
	

func is_full_health() -> bool:
	if max_health == current_health:
		return true
	return false
