class_name Entity
extends Area2D

"""
Metadata for Entities:
	previous_damage: int = The total number of damage from the last take_damage
	previous_damage_source: Entity = Source of the most recent damage that had a source.
"""

var max_health: int
var base_max_health: int
var current_health: int

var base_defense : Dictionary[COMMON_ENUMS.DAMAGE_TYPE, int]
var defense: Dictionary[COMMON_ENUMS.DAMAGE_TYPE, int]

var base_max_stamina: int
var max_stamina: int
var current_stamina: int

var base_max_mana: int
var max_mana: int
var current_mana: int

var base_mana_regen: int
var mana_regen: int

var hand_size: int
var base_hand_size: int

var current_status_effects: Dictionary[String, StatusEffect]

var current_shield: int
var shield_retention: float = 0.25
var base_shield_retention: float
var enemy_name : String

var health_bar: TextureProgressBar
var stamina_bar: TextureProgressBar
var mana_bar: TextureProgressBar

var health_bar_text : Label
var stamina_bar_text : Label
var mana_bar_text : Label

var health_tween: Tween
var stamina_tween: Tween
var mana_tween: Tween

var status_effect_bar : StatusEffectDisplay
var shield_node: Node2D

#ENEMY ONLY
var entity_title: String
var sprite: Sprite2D
var collision: CollisionShape2D
var enemy_card_container : Node2D
var base_sprite: Texture2D
const ENEMY_SPRITE_SIZE = 200
const DAMAGE_NUMBER = preload("res://game_data/scenes/scene_resources/damage_numbers/damage_number.tscn")

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

func regain_mana(mana:int = mana_regen) -> void:
	current_mana += mana;
	if current_mana > max_mana:
		current_mana = max_mana
	_update_stat_bars()

func _upkeep_regen_mana() -> void:
	current_mana += mana_regen
	if current_mana > max_mana:
		current_mana = max_mana
	_update_stat_bars()
	
func take_damage(damage: Damage) -> void:
	# This is for storing so the proper effects can be displayed after damage
	var final_damages: Dictionary[COMMON_ENUMS.DAMAGE_TYPE, int]
	var shield_array: Array = []
	var health_array: Array = []
	var total_damage: int = 0
	
	if damage.source != null:
		damage.outgoing_update()
		self.set_meta("previous_damage_source", damage.source)
		
	damage.incoming_update(self.current_status_effects)
	
	var strOut = entity_title+"|damage:";
	if current_shield > 0 && !damage.ignore_shield:
		shield_array = damage.damage_shield(current_shield, defense)
		current_shield -= shield_array[0]
		total_damage += shield_array[0]
		strOut += " shield: "+str(shield_array[0]);
	health_array = damage.damage_health(defense)
	current_health -= health_array[0]
	total_damage += health_array[0]
	strOut += " health: "+str(health_array[0]);
	
	DevConsole.add_message(strOut, Color.ORANGE_RED);
	self.set_meta("previous_damage", total_damage)
	
	if (damage.is_strike):
		_process_active_status(COMMON_ENUMS.TIMING.DAMAGED)
	
	damage_animation(health_array, shield_array)
	
	_update_stat_bars()
	_update_status()

func damage_animation(health_array, shield_array):
	pass

func gain_shield(shield : int) -> void:
	current_shield += shield
	
	DevConsole.add_message(entity_title+"|shield: +"+str(shield), Color.GREEN)
	
	_update_stat_bars()

func heal(healing: int) -> void:
	DevConsole.add_message(entity_title+"|health: +"+str(healing), Color.GREEN)
	
	current_health += healing
	if current_health > max_health:
		current_health = max_health
	_update_stat_bars()

func is_dead() -> bool:
	return current_health<=0
	
func add_status_stacks(status: StatusEffect, stacks: int, magnitude: float) -> void:
	DevConsole.add_message(entity_title+"|status: +"+status.data.name+" x"+str(int(magnitude)), Color.GREEN)
	
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

func _update_stat_bars() -> void:
		
	health_bar.max_value = max_health
	stamina_bar.max_value = max_stamina
	mana_bar.max_value = max_mana
	
	if health_tween and health_tween.is_running():
		health_tween.kill()
	if stamina_tween and stamina_tween.is_running():
		stamina_tween.kill()
	if mana_tween and mana_tween.is_running():
		mana_tween.kill()
	
	health_tween = _bar_tween(health_bar, current_health, 0.5)
	stamina_tween = _bar_tween(stamina_bar, current_stamina, 0.5)
	mana_tween = _bar_tween(mana_bar, current_mana, 0.5)
	
	health_bar_text.text = str(current_health) + "/" + str(max_health)
	mana_bar_text.text = str(current_mana) + "/" + str(max_mana)
	stamina_bar_text.text = str(current_stamina) + "/" + str(max_stamina)
	
	if(shield_node):
		if(current_shield <= 0):
			shield_node.hide()
		else:
			shield_node.show()
			shield_node.get_node("shield_label").text = str(current_shield)
			
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
			
func _bar_tween(target: TextureProgressBar, value: int, duration: float) -> Tween:
	var tween: Tween
	tween = health_bar.create_tween()
	tween.tween_property(target, "value", value, duration)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	return tween
	
func shake(intensity: float = 10.0, duration: float = 0.3, shakes: int = 8) -> void:
	var origin: Vector2 = sprite.position
	var tween: Tween = create_tween()
	for i in shakes:
		var falloff: float = 1.0 - float(i) / shakes
		var offset: Vector2 = Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		) * falloff
		tween.tween_property(sprite, "position", origin + offset, duration / shakes)
	tween.tween_property(sprite, "position", origin, 0.02)

func damage_flash() -> void:
	sprite.modulate = Color(1, 0.3, 0.3)
	create_tween().tween_property(sprite, "modulate", Color.WHITE, 0.25)
	
func heal_flash() -> void:
	sprite.modulate = Color(0.3, 1, 0.3)
	create_tween().tween_property(sprite, "modulate", Color.WHITE, 0.25)
	
func damage_numbers(damages: Dictionary[COMMON_ENUMS.DAMAGE_TYPE, int]) -> void:
	for key in damages:
		var number = DAMAGE_NUMBER.instantiate()
		number.z_index = 25
		number.global_position = global_position + Vector2(randf_range(-75, 75), -40)
		number.setup(damages[key], key)
		get_tree().current_scene.add_child(number)
