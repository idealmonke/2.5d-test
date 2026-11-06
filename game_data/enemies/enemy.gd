class_name Enemy
extends Entity

# cur idx
var idx : int

# Locations
var hand: EnemyHand
var library: EnemyLibrary

var tags: Array[String]

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
	
	entity_title = "Enemy #"+str(idx);
	
	#base_shield_retention = data.shield_retention
	#shield_retention = data.shield_retention
	
	_update_stat_bars()
	
	base_sprite = data.art
	
	tags = data.tags
	
	sprite.texture = base_sprite
	
	#TODO: make image scaling / position automatic
	var TEMP_SIZE = 300
	
	if(data.enemy_name=="goku"):
		TEMP_SIZE = 200
		sprite.position.y -= 100
	
	sprite.scale = Vector2(TEMP_SIZE,TEMP_SIZE) / base_sprite.get_size()
	sprite.scale = sprite.scale * data.art_scaling

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
	
func damage_animation(health_array, shield_array):
	var flash := damage_flash(sprite)
	var shake := shake(sprite)
	if shield_array != null && !shield_array.is_empty():
		damage_numbers(shield_array[1])
	damage_numbers(health_array[1])
	if flash and flash.is_running():
		await flash.finished
	if shake and shake.is_running():
		await shake.finished
