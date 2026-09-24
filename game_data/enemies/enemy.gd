class_name Enemy
extends Area2D

# cur idx
var idx : int

# Size of Texture
const ENEMY_SPRITE_SIZE = 200

# Locations
var hand: EnemyHand
var library: EnemyLibrary

# Enemy Stats
var max_health: int
var current_health: int
var defense: Dictionary[COMMON_ENUMS.DAMAGE_TYPE, int]
var current_shield: int
var shield_retention: float = 0.25
var base_shield_retention: float

# immutable stats
var enemy_name : String

var base_max_health: int
var base_max_stamina: int
var base_max_mana: int
var base_mana_regen: int
var base_hand_size: int
var base_defense : Dictionary[COMMON_ENUMS.DAMAGE_TYPE, int]


var hand_size: int
var max_stamina: int
var current_stamina: int
var max_mana: int
var current_mana: int
var mana_regen: int

var current_status_effects: Dictionary[String, StatusEffect]

# Child Nodes for UI control
var sprite: Sprite2D
var collision: CollisionShape2D
var health_bar: TextureProgressBar
var stamina_bar: TextureProgressBar
var mana_bar: TextureProgressBar

var shield_node: Node2D

var enemy_card_container : Node2D

var health_bar_text : Label
var stamina_bar_text : Label
var mana_bar_text : Label

var status_effect_bar : StatusEffectDisplay

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
	
	shield_node = $shield

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
	current_mana += mana_regen
	if current_mana > max_mana:
		current_mana = max_mana
	_update_stat_bars()
	
func take_damage(damage: Damage) -> void:
	if damage.source != null:
		damage.outgoing_update()
		
	damage.incoming_update(self.current_status_effects)
	
	var strOut = "enemy"+str(idx)+"|damage:";
	if current_shield > 0 && !damage.ignore_shield:
		var variable = damage.damage_shield(current_shield, defense)
		current_shield -= variable
		strOut += " shield: "+str(variable);
	var healthLost = damage.damage_health(defense);
	current_health -= healthLost
	strOut += " health: "+str(healthLost);
	
	DevConsole.add_message(strOut, Color.ORANGE_RED);
	
	if (damage.is_strike):
		_process_active_status(COMMON_ENUMS.TIMING.DAMAGED)
	
	_update_stat_bars()
	_update_status()

func gain_shield(shield : int) -> void:
	current_shield += shield
	_update_stat_bars()

func is_dead() -> bool:
	return current_health<=0
	
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
	status_effect_bar.reset(current_status_effects)

func _update_stat_bars() -> void:
	health_bar.value = current_health
	stamina_bar.value = current_stamina
	mana_bar.value = current_mana
	
	health_bar.max_value = max_health
	stamina_bar.max_value = max_stamina
	stamina_bar.max_value = max_mana
	
	health_bar_text.text = str(current_health)+"/"+str(max_health)
	stamina_bar_text.text = str(current_stamina)+"/"+str(max_stamina)
	mana_bar_text.text = str(current_mana)+"/"+str(max_mana)
	
	if(current_shield <= 0):
		shield_node.hide()
	else:
		shield_node.show()
		shield_node.get_node("shield_label").text = str(current_shield)
	
func initialize_data(data: EnemyData, cur_idx : int) -> void:
	enemy_name = data.enemy_name
	idx = cur_idx
	
	base_max_health = data.max_health
	base_max_stamina = data.max_stamina
	base_max_mana = data.max_mana
	
	base_mana_regen = data.mana_regen
	base_defense = data.defense
	
	max_health = data.max_health
	max_stamina = data.max_stamina
	max_mana = data.max_mana
	mana_regen = data.mana_regen
	defense = data.defense
	
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
	var TEMP_SIZE = 300
	
	if(data.enemy_name=="goku"):
		TEMP_SIZE = 200
		sprite.position.y -= 100
	
	sprite.scale = Vector2(TEMP_SIZE,TEMP_SIZE) / base_sprite.get_size()

func setup_library(lib : Array[EnemyCard]) -> void:
	hand = EnemyHand.new()
	hand.init(self, lib)

func process_turn() -> void:
	BattleController.active_turn = self
	
	current_shield = int(current_shield * shield_retention)
	_update_stat_bars()
	
	_process_active_status(COMMON_ENUMS.TIMING.START)
	update_passive_effects()
	_process_status_stacks()
	
	# Upkeep
	_upkeep_regen_mana()
	_upkeep_regen_stamina()
	
	if(current_health<=0):
		return
	
	DevConsole.add_message("enemy"+str(idx)+": processing turn", Color.RED);
	hand.draw_hand(hand_size)
	await hand.play_hand()
	hand.replenish_hand()
	
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
	
	_update_status()
func _process_active_status(timing: COMMON_ENUMS.TIMING) -> void:
	for key in current_status_effects:
		var status: StatusEffect = current_status_effects.get(key)
		if (status.data.abilities.has(timing)):
			status.data.abilities[timing].execute(self, status)
