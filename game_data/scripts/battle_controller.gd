class_name battle_controller
extends Node

var data: battle_data
var active_turn: Variant

# Lambda Functions for game events, modified by perks
var current_draw_card: Callable
var current_discard_card: Callable 

var current_state: COMMON_ENUMS.BATTLE_STATE = COMMON_ENUMS.BATTLE_STATE.BEGIN_BATTLE

var display_grid: skill_card_display_grid

# Necessary UI Stuff
var end_turn_button: Button
var win_screen : PanelContainer

#Targeting Manager
var targeting_manager_instance : targeting_manager

signal display_signal

# Init Battle Controller
func _ready() -> void:
	data = battle_data.new()
	data.player = battle_player_data.new()
	data.player.base_defense.set(COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL, 6)
	data.player.defense = data.player.base_defense.duplicate()
	
	
	current_draw_card = _default_draw_card
	current_discard_card = _default_discard_card
	
func _input(event: InputEvent) -> void:
	#Because of autoload
	var scene : Node = get_tree().current_scene
	if  scene != null and scene.name != "PrototypeBattle":
		return
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_Q:
			draw_card()
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_W:
			dredge_card()
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_E:
			replenish_discard()
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_R:
			discard_front()
	#if event is InputEventKey:
	#	if event.pressed and event.keycode == KEY_P:
	#		for enem in data.enemies:
	#			enem.process_turn()
				
func setup(battle_scene: Node, discard: Node, hand: Node, library: Node, tm : targeting_manager, end_turn, display: skill_card_display_grid, win: PanelContainer, effect_bar: status_effect_display, shield_node : Node2D) -> void:
	data.discard = discard
	data.hand = hand
	data.library = library
	
	win_screen = win
	
	targeting_manager_instance = tm
	display_grid = display
	end_turn_button = end_turn
	
	data.player.status_effect_bar = effect_bar
	data.player.shield_node = shield_node
	
	#(must be run post enemy creation): _change_state(COMMON_ENUMS.BATTLE_STATE.PLAYER_UPKEEP)

# Immutable Game Actions (These are what we call elsewhere)
func draw_card() -> void:
	if data.library.is_empty():
		return
	# Some Stuff
	current_draw_card.call()
	# Some More Stuff
	
func discard_card(card: skill_card) -> void:
	# Some Stuff
	current_discard_card.call(card)
	# Some More Stuff
	
func dredge_card() -> void:
	var card = data.library.pop_top_card()
	if card == null:
		return
	data.discard.add_card(card)
	card.interactable_state = COMMON_ENUMS.INTERACT_STATE.DISCARD
	card.set_front()

func replenish_discard() -> void:
	while data.discard.is_empty() == false:
		var card = data.discard.pop_front_card()
		data.library.push_to_top(card)
		card.interactable_state = COMMON_ENUMS.INTERACT_STATE.LIBRARY
		card.set_back()
	data.library.shuffle()
	
func replenish_single(card: skill_card) -> void:
	var temp = data.discard.pop_card(card)
	if temp == null:
		return
	data.library.push_to_top(temp)
	temp.interactable_state = COMMON_ENUMS.INTERACT_STATE.LIBRARY
	temp.set_back()
	data.library.shuffle()
	
func discard_front() -> void:
	var temp = data.hand.pop_front()
	if temp == null:
		return
	data.discard.add_card(temp)
	temp.interactable_state = COMMON_ENUMS.INTERACT_STATE.DISCARD
	
func play_card(card: skill_card) -> void:
	_change_state(COMMON_ENUMS.BATTLE_STATE.CARD_PLAYING)
	data.hand.pop_card(card)
	card.z_index_modifier = 10
	
	# pause code
	#await get_tree().create_timer(2.0).timeout
	var targets = null
	targets = await targeting_manager_instance.select_targets(card)
	
	card.z_index_modifier = 0
	
	if not targets:
		_change_state(COMMON_ENUMS.BATTLE_STATE.PLAYER_PLAYING)
		data.hand.add_card(card)
		card.interactable_state = COMMON_ENUMS.INTERACT_STATE.HAND
		
		BattleController.data.player.regen_stamina(card.stamina_cost)
		BattleController.data.player.regain_mana(card.mana_cost)
	else:
		await card.ability.execute(targets)
		data.discard.add_card(card)
		_change_state(COMMON_ENUMS.BATTLE_STATE.PLAYER_PLAYING)

# Mutable Game Actions (Default lambda functions, sometimes replaced by perks)
func _default_draw_card() -> void:
	var card = data.library.pop_top_card()
	if card == null:
		return
	data.hand.add_card(card)
	card.interactable_state = COMMON_ENUMS.INTERACT_STATE.HAND
	card.set_front()

func _default_discard_card(card: skill_card) -> void:
	data.hand.pop_card(card)
	data.discard.add_card(card)
	card.interactable_state = COMMON_ENUMS.INTERACT_STATE.DISCARD

#func _process_active_status(timing: COMMON_ENUMS.TIMING) -> void:
	#for key in data.player.current_status_effects:
		#if data.player.current_status_effects.has(key) && data.player.current_status_effects.get(key).timing == timing:
			#data.player.current_status_effects.get(key).execute(self)
			#data.player.current_status_effects.get(key).stacks -= 1
			#if data.player.current_status_effects.get(key).stacks == 0:
				#data.player.current_status_effects.erase(key)

func _player_upkeep() -> COMMON_ENUMS.BATTLE_STATE:
	
	data.player.process_statuses(COMMON_ENUMS.TIMING.START)
	data.player._upkeep_regen_mana()
	data.player._upkeep_regen_stamina()
	
	data.player.current_shield = int(data.player.current_shield * data.player.shield_retention)
	data.player._update_stat_bars()
	
	var current_handsize = data.player.hand_size
	for i in range(current_handsize):
		draw_card()
	
	return COMMON_ENUMS.BATTLE_STATE.PLAYER_PLAYING

func _player_endstep() -> COMMON_ENUMS.BATTLE_STATE:
	var old_cards: Array[skill_card] = data.hand.pop_each()
	old_cards.append_array(data.discard.pop_exhausted())
	
	data.discard.exhaust_cards()
	
	for card in old_cards:
		card.interactable_state = COMMON_ENUMS.INTERACT_STATE.LIBRARY
		card.exhausted = false
		card.set_back()
	data.library.push_each(old_cards)
	return COMMON_ENUMS.BATTLE_STATE.ENEMY_TURNS
	
func _enemy_turns() -> COMMON_ENUMS.BATTLE_STATE:
	for enem in data.enemies:
		await enem.process_turn()
	
	await get_tree().create_timer(1.0).timeout
	
	#for enem in data.enemies:
	#	enem.hand.replenish_hand()
	
	return COMMON_ENUMS.BATTLE_STATE.PLAYER_UPKEEP
	
func _player_playing() -> void:
	# Gameplay related setup
	# UI/Animation stuff in the state functions
	
	
	
	pass



func _end_turn() -> void:
	_change_state(COMMON_ENUMS.BATTLE_STATE.PLAYER_END)

func _process_deaths() -> bool:
	for enem in data.enemies.duplicate():
		if enem.is_dead():
			data.enemies.erase(enem)
			enem.queue_free()
	
	return data.enemies.size()==0

## Used for managing the actions at start of state like animations etc
func _on_enter_state(state: COMMON_ENUMS.BATTLE_STATE) -> void:
	match state:
		COMMON_ENUMS.BATTLE_STATE.PLAYER_UPKEEP:
			pass
		COMMON_ENUMS.BATTLE_STATE.PLAYER_END:
			pass
		COMMON_ENUMS.BATTLE_STATE.PLAYER_PLAYING:
			end_turn_button.show()
		COMMON_ENUMS.BATTLE_STATE.ENEMY_TURNS:
			end_turn_button.hide()
		COMMON_ENUMS.BATTLE_STATE.BEGIN_BATTLE:
			pass
		COMMON_ENUMS.BATTLE_STATE.CARD_PLAYING:
			pass
		COMMON_ENUMS.BATTLE_STATE.DISPLAYING:
			pass
		COMMON_ENUMS.BATTLE_STATE.WIN_SCREEN:
			end_turn_button.hide()
			win_screen.show()

## Used for managing the actions at end of state like animations etc
func _on_exit_state(state: COMMON_ENUMS.BATTLE_STATE) -> void:
	match state:
		COMMON_ENUMS.BATTLE_STATE.PLAYER_UPKEEP:
			pass
		COMMON_ENUMS.BATTLE_STATE.PLAYER_END:
			pass
		COMMON_ENUMS.BATTLE_STATE.PLAYER_PLAYING:
			end_turn_button.hide()
		COMMON_ENUMS.BATTLE_STATE.ENEMY_TURNS:
			pass
		COMMON_ENUMS.BATTLE_STATE.BEGIN_BATTLE:
			# DO NOTHING HERE
			pass
		COMMON_ENUMS.BATTLE_STATE.CARD_PLAYING:
			pass
		COMMON_ENUMS.BATTLE_STATE.DISPLAYING:
			pass

func _change_state(new_state: COMMON_ENUMS.BATTLE_STATE) -> void:
	_on_exit_state(current_state)
	current_state = new_state
	if current_state != COMMON_ENUMS.BATTLE_STATE.WIN_SCREEN and _process_deaths():
		_change_state(COMMON_ENUMS.BATTLE_STATE.WIN_SCREEN)
		return
	_on_enter_state(current_state)
	match current_state:
		COMMON_ENUMS.BATTLE_STATE.PLAYER_UPKEEP:
			_change_state(_player_upkeep())
		COMMON_ENUMS.BATTLE_STATE.PLAYER_END:
			_change_state(_player_endstep())
		COMMON_ENUMS.BATTLE_STATE.PLAYER_PLAYING:
			_player_playing()
		COMMON_ENUMS.BATTLE_STATE.ENEMY_TURNS:
			var state = await _enemy_turns()
			_change_state(state)
		COMMON_ENUMS.BATTLE_STATE.BEGIN_BATTLE:
			# DO NOTHING HERE, JUST STOPS THE EXIT STATE FROM CALLING INITIALLY
			pass
		COMMON_ENUMS.BATTLE_STATE.CARD_PLAYING:
			# STATE 
			
			print("playing")
			
			pass
		COMMON_ENUMS.BATTLE_STATE.DISPLAYING:
			pass
		COMMON_ENUMS.BATTLE_STATE.WIN_SCREEN:
			pass
