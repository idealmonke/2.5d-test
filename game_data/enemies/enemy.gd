class_name enemy
extends Area2D

var controller: battle_controller

# Locations
var hand: enemy_hand
var library: enemy_library

# Enemy Stats
var max_health: int
var current_health: int
var defense: Dictionary[String, int]

# immutable stats
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

var passive_status_effects: Dictionary[COMMON_ENUMS.PASSIVE_STATUS_EFFECTS, int]
var active_status_effects: Dictionary[COMMON_ENUMS.ACTIVE_STATUS_EFFECTS, active_status_effect]

# Child Nodes for UI control
var sprite: Sprite2D
var collision: CollisionShape2D
var health_bar: TextureProgressBar
var stamina_bar: TextureProgressBar
var mana_bar: TextureProgressBar

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

func _process_active_status(timing: COMMON_ENUMS.TIMING) -> void:
	for key in active_status_effects:
		if active_status_effects.has(key) && active_status_effects.get(key).timing == timing:
			active_status_effects.get(key).execute(self)
			active_status_effects.get(key).stacks -= 1
			if active_status_effects.get(key).stacks == 0:
				active_status_effects.erase(key)

func _update_stat_bars() -> void:
	health_bar.value = current_health
	stamina_bar.value = current_stamina
	mana_bar.value = current_mana
	
func initialize_data(data: enemy_data) -> void:
	max_health = data.max_health
	max_stamina = data.max_stamina
	max_mana = data.max_mana
	
	current_health = max_health
	current_mana = max_mana
	current_stamina = max_stamina
	
	base_sprite = data.art

func process_turn() -> void:
	# Upkeep
	_upkeep_regen_mana()
	_upkeep_regen_stamina()
	_process_active_status(COMMON_ENUMS.TIMING.START)
	
	# Playing Turn
	hand.draw_hand(hand_size)
	hand.play_hand()
	
	await get_tree().create_timer(2.0).timeout	
	# End of Turn
	hand.replenish_hand()
