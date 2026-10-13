class_name BattlePlayerData
extends Entity

var character_classes: Array[COMMON_ENUMS.CHARACTER_CLASSES]

func init_bars(hp_bar, hp_label, m_bar, m_label, s_bar, s_label, status_bars) -> void:
	health_bar = hp_bar
	health_bar_text = hp_label
	health_bar.max_value = max_health
	
	mana_bar = m_bar
	mana_bar_text = m_label
	mana_bar.max_value = max_mana
	
	stamina_bar = s_bar
	stamina_bar_text = s_label
	stamina_bar.max_value = max_stamina
	
	status_effect_bar = status_bars
	
	_update_stat_bars()

func process_statuses(timing: COMMON_ENUMS.TIMING) -> void:
	_process_active_status(timing)
	update_passive_effects()
	_process_status_stacks()
	_update_status()
