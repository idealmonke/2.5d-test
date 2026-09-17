class_name reactant_ability
extends skill_card_ability

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : targeting_info) -> void:
	for effect_name in BattleController.data.player.current_status_effects:
		var effect : status_effect = BattleController.data.player.current_status_effects[effect_name]
		
		var status: status_effect = status_effect.new(effect.data)
		BattleController.data.player.add_status_stacks(status, 1, 1)
