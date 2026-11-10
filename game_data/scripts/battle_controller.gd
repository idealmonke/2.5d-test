class_name battle_controller
extends Node

var data: BattleData
var active_turn: Variant

# Lambda Functions for game events, modified by perks
var current_draw_card: Callable
var current_discard_card: Callable 

var current_state: COMMON_ENUMS.BATTLE_STATE = COMMON_ENUMS.BATTLE_STATE.BEGIN_BATTLE

var display_grid: SkillCardDisplayGrid

# Necessary UI Stuff
var end_turn_button: Button
var win_screen : PanelContainer

#Targeting / Maybe Manager
var targeting_manager_instance : TargetingManager
var maybe_manager_instance : MaybeManager

var is_finished : bool

#Devlog
var devlog: PanelContainer

var banner: AnimatedBanner

# Data Tracking for card abilities
var cards_drawn_for_turn: int = 0

@warning_ignore("unused_signal")
signal display_signal

# Init Battle Controller
func _ready() -> void:
	data = BattleData.new()
	data.player = BattlePlayerData.new()
	data.player.base_defense.set(COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL, 6)
	data.player.defense = data.player.base_defense.duplicate()
	
	current_draw_card = _default_draw_card
	current_discard_card = _default_discard_card
	is_finished = false
	
func _input(event: InputEvent) -> void:
	var scene : Node = get_tree().current_scene
	if  scene != null and scene.name != "PrototypeBattle":
		return
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_Q:
			draw_card()
			
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SLASH:
			devlog.visible = !devlog.visible
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_T:
			print(get_viewport().gui_get_hovered_control())
	
	#testing purposes
	return;
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_W:
			dredge_card()
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_E:
			replenish_discard()
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_R:
			discard_front()
				
func setup(discard: Node, hand: Node, library: Node, tm : TargetingManager, mm: MaybeManager, end_turn, display: SkillCardDisplayGrid, win: PanelContainer, effect_bar: StatusEffectDisplay, shield_node : Node2D, devlog: PanelContainer, banner: AnimatedBanner) -> void:
	data.discard = discard
	data.hand = hand
	data.library = library
	
	self.devlog = devlog
	win_screen = win
	
	targeting_manager_instance = tm
	maybe_manager_instance = mm
	display_grid = display
	end_turn_button = end_turn
	
	data.player.status_effect_bar = effect_bar
	data.player.shield_node = shield_node
	self.banner = banner
	
	is_finished = false

# Immutable Game Actions (These are what we call elsewhere)
func draw_card() -> void:
	if data.library.is_empty():
		return
	# Some Stuff
	current_draw_card.call()
	cards_drawn_for_turn += 1
	# Some More Stuff
	
func discard_card(card: SkillCard) -> void:
	# Some Stuff
	if card.discard_castable == COMMON_ENUMS.DISCARD_CASTABLE_MODES.FREE || (card.discard_castable == COMMON_ENUMS.DISCARD_CASTABLE_MODES.NORMAL && card.stamina_cost <= data.player.current_stamina && card.mana_cost <= data.player.current_mana):
		await play_card_discard(card) 
	else:
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
	
func replenish_single(card: SkillCard) -> void:
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
	
func play_card(card: SkillCard) -> void:
	_change_state(COMMON_ENUMS.BATTLE_STATE.CARD_PLAYING)
	card.interactable_state = COMMON_ENUMS.INTERACT_STATE.PLAYING
	data.hand.pop_card(card)
	card.z_index_modifier = 10
	
	var targets = null
	targets = await targeting_manager_instance.select_targets(card)
	
	card.z_index_modifier = 0
	
	if not targets:
		data.hand.add_card(card)
		card.interactable_state = COMMON_ENUMS.INTERACT_STATE.HAND

	else:
		DevConsole.add_message("skillcard: "+card.card_name, Color.SKY_BLUE)
		BattleController.data.player.expend_stamina(card.stamina_cost)
		BattleController.data.player.expend_mana(card.mana_cost)
		await card.ability.execute(targets)
		data.discard.add_card(card)
	_change_state(COMMON_ENUMS.BATTLE_STATE.PLAYER_PLAYING)
	
## Always ends in discard
func play_card_discard(card: SkillCard) -> void:
	_change_state(COMMON_ENUMS.BATTLE_STATE.CARD_PLAYING)
	card.interactable_state = COMMON_ENUMS.INTERACT_STATE.PLAYING
	card.z_index_modifier = 10
	
	var targets = null
	targets = await targeting_manager_instance.select_targets(card)
	
	card.z_index_modifier = 0
	
	if not targets:
		data.discard.add_card(card)
		card.interactable_state = COMMON_ENUMS.INTERACT_STATE.DISCARD
		
	else:
		DevConsole.add_message("skillcard: "+card.card_name, Color.SKY_BLUE)
		if card.discard_castable == COMMON_ENUMS.DISCARD_CASTABLE_MODES.NORMAL:
			BattleController.data.player.expend_stamina(card.stamina_cost)
			BattleController.data.player.expend_mana(card.mana_cost)
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

func _default_discard_card(card: SkillCard) -> void:
	data.hand.pop_card(card)
	data.discard.add_card(card)
	card.interactable_state = COMMON_ENUMS.INTERACT_STATE.DISCARD

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
	var old_cards: Array[SkillCard] = data.hand.pop_each()
	old_cards.append_array(data.discard.pop_exhausted())
	
	data.discard.exhaust_cards()
		
	for card in old_cards:
		card.interactable_state = COMMON_ENUMS.INTERACT_STATE.LIBRARY
		card.exhausted = false
		card.set_back()
	data.library.push_each(old_cards)
	return COMMON_ENUMS.BATTLE_STATE.ENEMY_TURNS

func _enemy_turns() -> COMMON_ENUMS.BATTLE_STATE:
	for enem in data.enemies.duplicate():
		await enem.process_turn()
		var test = process_deaths()
		if(test!="none"):
			return COMMON_ENUMS.BATTLE_STATE.END_SCREEN
	
	await get_tree().create_timer(1.0).timeout
	
	return COMMON_ENUMS.BATTLE_STATE.PLAYER_UPKEEP
	
func _player_playing() -> void:
	# Gameplay related setup
	# UI/Animation stuff in the state functions
	
	
	
	pass



func _end_turn() -> void:
	_change_state(COMMON_ENUMS.BATTLE_STATE.PLAYER_END)

func process_deaths() -> String:
	for enem in data.enemies.duplicate():
		if enem.is_dead():
			data.enemies.erase(enem)
			enem.queue_free()
	
	#DevConsole.add_message("processing death",Color.DARK_GREEN)
	
	if data.player.current_health<=0:
		return "lose"
	if data.enemies.size()==0:
		return "win"
	return "none"

## Used for managing the actions at start of state like animations etc
func _on_enter_state(state: COMMON_ENUMS.BATTLE_STATE) -> void:
	match state:
		COMMON_ENUMS.BATTLE_STATE.PLAYER_UPKEEP:
			await banner.play_banner("PLAYER TURN", Color.DARK_BLUE, Color.AZURE)
			pass
		COMMON_ENUMS.BATTLE_STATE.PLAYER_END:
			cards_drawn_for_turn = 0
		COMMON_ENUMS.BATTLE_STATE.PLAYER_PLAYING:
			end_turn_button.show()
		COMMON_ENUMS.BATTLE_STATE.ENEMY_TURNS:
			end_turn_button.hide()
			await banner.play_banner("ENEMY TURNS", Color.DARK_RED, Color.AZURE)
		COMMON_ENUMS.BATTLE_STATE.BEGIN_BATTLE:
			pass
		COMMON_ENUMS.BATTLE_STATE.CARD_PLAYING:
			pass
		COMMON_ENUMS.BATTLE_STATE.DISPLAYING:
			pass
		COMMON_ENUMS.BATTLE_STATE.END_SCREEN:
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
			pass
		COMMON_ENUMS.BATTLE_STATE.CARD_PLAYING:
			pass
		COMMON_ENUMS.BATTLE_STATE.DISPLAYING:
			pass

func _change_state(new_state: COMMON_ENUMS.BATTLE_STATE) -> void:
	await _on_exit_state(current_state)
	current_state = new_state
	var state_to_string = COMMON_ENUMS.BATTLE_STATE.keys()[new_state];
	
	DevConsole.add_message("state: "+state_to_string, Color.YELLOW)
	
	var is_dead = process_deaths()
	if is_dead!="none" and not is_finished:
		is_finished = true
		if(is_dead=="lose"):
			win_screen.get_node("vbox/label").text = "You died\n\nTry again"
		if(is_dead=="win"):
			win_screen.get_node("vbox/label").text = "You defeated all the enemies and won!\n\nUse the settings menu to try new 
enemies or decks."
		_change_state(COMMON_ENUMS.BATTLE_STATE.END_SCREEN)
		return
	await _on_enter_state(current_state)
	match current_state:
		COMMON_ENUMS.BATTLE_STATE.PLAYER_UPKEEP:
			_change_state(_player_upkeep())
		COMMON_ENUMS.BATTLE_STATE.PLAYER_END:
			_change_state(_player_endstep())
		COMMON_ENUMS.BATTLE_STATE.PLAYER_PLAYING:
			_player_playing()
		COMMON_ENUMS.BATTLE_STATE.ENEMY_TURNS:
			var state = await _enemy_turns()
			
			
			#if not is_finished:1
			_change_state(state)
		COMMON_ENUMS.BATTLE_STATE.BEGIN_BATTLE:
			# DO NOTHING HERE, JUST STOPS THE EXIT STATE FROM CALLING INITIALLY
			pass
		COMMON_ENUMS.BATTLE_STATE.CARD_PLAYING:
			# STATE 
			
			
			pass
		COMMON_ENUMS.BATTLE_STATE.DISPLAYING:
			pass
		COMMON_ENUMS.BATTLE_STATE.END_SCREEN:
			pass
