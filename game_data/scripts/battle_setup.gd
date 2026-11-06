extends Node

const SKILL_CARD_SCENE = preload("res://game_data/skill_cards/skill_card.tscn")
var BATTLE_CONFIG = preload("res://game_data/battle_config.tres")
const ENEMY_SCENE = preload("res://game_data/enemies/enemy.tscn")
const ENEMY_CARD_SCENE = preload("res://game_data/enemies/enemy_card.tscn")

func _ready() -> void:
	BATTLE_CONFIG = load("res://game_data/battle_config.tres")
	
	DevConsole.setup($devlog)
	BattleController.data.player.init_bars(	$player_stat_bars/health_bar, 
										$player_stat_bars/health_bar/health_label,
										$player_stat_bars/mana_bar,
										$player_stat_bars/mana_bar/mana_label,
										$player_stat_bars/stamina_bar,
										$player_stat_bars/stamina_bar/stamina_label,
										$player_stat_bars/status_effect_display)
	
	BattleController.setup($discard, $hand, $library, $targeting_manager, $maybe_manager, $end_turn, $skill_card_display_grid, $win_panel, $status_effect_display, $shield, $devlog, $banner)
	
	_init_player_cards()
	_init_enemies()
	_init_player_stats(BATTLE_CONFIG.party.character_ids)
	
	BattleController._change_state(COMMON_ENUMS.BATTLE_STATE.PLAYER_UPKEEP)

func _on_end_turn_pressed() -> void:
	BattleController._end_turn()

func _init_player_cards() -> void:
	SkillCardRegistry.load_card_art()
	
	var party: PartyData = BATTLE_CONFIG.party
	var cards: Array[int] = party.card_ids
	
	for card in cards:
		var data: CardData = SkillCardRegistry.get_card_data(card)
		#if(data.card_id!=7004):
			#continue;
		var card_instance: SkillCard = SKILL_CARD_SCENE.instantiate()
		
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
		
		var data : EnemyData = EnemyRegistry.get_enemy_data(id)
		if(data.enemy_name=="goku"):
			for i in range(200):
				data.card_ids.append(1)
		
		var enemy_instance : Enemy = ENEMY_SCENE.instantiate()
		$enemy_storage.add_child(enemy_instance)
		enemy_instance.initialize_data(data, idx)
		
		var enemy_cards : Array[EnemyCard]
		for card_id in data.card_ids:
			var enemy_card_instance : EnemyCard = ENEMY_CARD_SCENE.instantiate()
			var e_card_data : EnemyCardData = EnemyCardRegistry.get_card_data(card_id)
			enemy_instance.enemy_card_container.add_child(enemy_card_instance)
			enemy_card_instance.initialize_card(e_card_data)
			enemy_cards.append(enemy_card_instance)
		
		enemy_instance.setup_library(enemy_cards)
		
		BattleController.data.enemies.append(enemy_instance)
		enemy_instance.position = BattleController.data.enemy_locations[idx]

func _init_player_stats(character_ids: Array[int]) -> void:
	
	
	var characters: Array[CharacterData] = []
	for id in character_ids:
		characters.append(CharacterDataRegistry.get_character_data(id))
	
	var stats = CharacterDataRegistry.calculate_stats(characters)
	
	var max_health: int = stats.max_health
	var max_mana: int = stats.max_mana
	var mana_regen: int = stats.mana_regen
	var max_stamina: int = stats.max_stamina
	var shield_retention: float = stats.shield_retention
	var defense: Dictionary[COMMON_ENUMS.DAMAGE_TYPE, int] = stats.defense
	var handsize: int = stats.handsize
	
	var player: BattlePlayerData = BattleController.data.player
	
	for character in characters:
		if character.main_class not in player.character_classes:
			player.character_classes.push_back(character.main_class)
		if character.multi_class != COMMON_ENUMS.CHARACTER_CLASSES.NONE && character.multi_class not in player.character_classes:
			player.character_classes.push_back(character.multi_class)
	
	player.base_max_health = max_health
	player.max_health = max_health
	player.current_health = max_health
	
	player.base_max_mana = max_mana
	player.max_mana = max_mana
	player.current_mana = max_mana
	
	player.base_mana_regen = mana_regen
	player.mana_regen = mana_regen
	
	player.base_max_stamina = max_stamina
	player.max_stamina = max_stamina
	player.current_stamina = max_stamina

	player.base_shield_retention = shield_retention
	player.shield_retention = shield_retention
	player.current_shield = 0
	
	player.base_hand_size = handsize
	player.hand_size = handsize
	
	player.base_defense = defense
	player.defense = defense
	
	player.current_status_effects.clear()
	
	player._update_stat_bars()
	player._update_status()
