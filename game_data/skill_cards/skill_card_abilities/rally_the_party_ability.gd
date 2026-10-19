class_name rally_the_party_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.NONE

func execute(targets : TargetingInfo) -> void:
	for i in range(BattleController.data.player.character_classes.size()):
		BattleController.draw_card()
