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
var max_health: int
var current_health: int
var defense: Dictionary[COMMON_ENUMS.DAMAGE_TYPE, int]

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

var current_status_effects: Dictionary[COMMON_ENUMS.STATUS_EFFECT, status_effect]

# Child Nodes for UI control
var sprite: Sprite2D
var collision: CollisionShape2D
var health_bar: TextureProgressBar
var stamina_bar: TextureProgressBar
var mana_bar: TextureProgressBar

var health_bar_text : Label
var stamina_bar_text : Label
var mana_bar_text : Label

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

func take_damage(type: COMMON_ENUMS.DAMAGE_TYPE, damage: int) -> int:
	if defense.has(type):
		damage -= defense.get(type)
		if damage < 0:
			damage = 0
	current_health -= damage
	_update_stat_bars()
	return damage
	
	
func add_status_stacks(status: COMMON_ENUMS.STATUS_EFFECT, stacks: int, magnitude: float) -> void:
	if current_status_effects.has(status):
		var cur = current_status_effects.get(status)
		cur.stacks += stacks
		if cur.data.magnitude < magnitude:
			cur.data.magnitude = magnitude
	else:
		var cur = status_effect.new(null)

func _process_active_status(timing: COMMON_ENUMS.TIMING) -> void:
	for key in current_status_effects:
		if (current_status_effects.get(key) == COMMON_ENUMS.STATUS_TYPE.ACTIVE || current_status_effects.get(key) == COMMON_ENUMS.STATUS_TYPE.BOTH) && current_status_effects.get(key).data.timing == timing:
			current_status_effects.get(key).data.execute(self)
			current_status_effects.get(key).stacks -= 1
			current_status_effects.get(key).duration_active += 1
			if current_status_effects.get(key).stacks == 0:
				current_status_effects.erase(key)

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
	
	max_health = data.max_health
	max_stamina = data.max_stamina
	max_mana = data.max_mana
	
	current_health = max_health
	current_mana = max_mana
	current_stamina = max_stamina
	
	_update_stat_bars()
	
	base_sprite = data.art
	sprite.texture = base_sprite
	
	#TODO: make image scaling / position automatic
	var TEMP_SIZE = 400
	
	if(data.enemy_name=="goku"):
		TEMP_SIZE = 200
		sprite.position.y -= 100
	
	sprite.scale = Vector2(TEMP_SIZE,TEMP_SIZE) / base_sprite.get_size()

func process_turn() -> void:
	# Upkeep
	_upkeep_regen_mana()
	_upkeep_regen_stamina()
	_process_active_status(COMMON_ENUMS.TIMING.START)
	
	# Playing Turn
	#hand.draw_hand(hand_size)
	#hand.play_hand()
	
	# End of Turn
	#hand.replenish_hand()

func is_full_health() -> bool:
	if max_health == current_health:
		return true
	return false
