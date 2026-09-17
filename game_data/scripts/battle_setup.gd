extends Node

const SKILL_CARD_SCENE = preload("res://game_data/skill_cards/skill_card.tscn")
const BATTLE_CONFIG = preload("res://game_data/battle_config.tres")

const ENEMY_SCENE = preload("res://game_data/enemies/enemy.tscn")

const ENEMY_CARD_SCENE = preload("res://game_data/enemies/enemy_card.tscn")

func _ready() -> void:
	
	BattleController.data.player.init_bars(	$player_stat_bars/health_bar, 
										$player_stat_bars/health_bar/health_label,
										$player_stat_bars/mana_bar,
										$player_stat_bars/mana_bar/mana_label,
										$player_stat_bars/stamina_bar,
										$player_stat_bars/stamina_bar/stamina_label,
										$player_stat_bars/status_effect_display)
	
	BattleController.setup(self, $discard, $hand, $library, $targeting_manager, $end_turn, $skill_card_display_grid, $win_panel, $status_effect_display, $shield)
	
	_init_player_cards()
	_init_enemies()
	
	BattleController._change_state(COMMON_ENUMS.BATTLE_STATE.PLAYER_UPKEEP)

func _on_end_turn_pressed() -> void:
	BattleController._end_turn()

func _init_player_cards() -> void:
	var party: Party = BATTLE_CONFIG.party
	var cards: Array[int] = party.card_ids
	
	for card in cards:
		var data: card_data = skill_card_registry.get_card_data(card)
		var card_instance: skill_card = SKILL_CARD_SCENE.instantiate()
		
		card_instance.set_locs($library, $discard);
		
		$card_storage.add_child(card_instance)
		card_instance.initialize_card(data)
		BattleController.data.library.push_to_top(card_instance)
	BattleController.data.library.shuffle()

func _init_enemies() -> void:
	var enemyIDs : Array[int] = BATTLE_CONFIG.enemyIDs
	BattleController.data.enemies = []
	
	for idx in range(3):
		var id = enemyIDs[idx]
		
		if id == -1:
			continue
		
		var data : enemy_data = enemy_registry.get_enemy_data(id)
		if(data.enemy_name=="goku"):
			for i in range(200):
				data.card_ids.append(1)
		
		var enemy_instance : enemy = ENEMY_SCENE.instantiate()
		$enemy_storage.add_child(enemy_instance)
		enemy_instance.initialize_data(data, idx)
		
		var enemy_cards : Array[enemy_card]
		for card_id in data.card_ids:
			var enemy_card_instance : enemy_card = ENEMY_CARD_SCENE.instantiate()
			var e_card_data : enemy_card_data = enemy_card_registry.get_card_data(card_id)
			enemy_instance.enemy_card_container.add_child(enemy_card_instance)
			enemy_card_instance.initialize_card(e_card_data, idx)
			enemy_cards.append(enemy_card_instance)
		
		enemy_instance.setup_library(enemy_cards)
		
		#BattleController.data.enemies[idx] = enemy_instance
		BattleController.data.enemies.append(enemy_instance)
		enemy_instance.position = BattleController.data.enemy_locations[idx]
