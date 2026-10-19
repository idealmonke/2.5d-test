class_name grasping_stars_ability
extends SkillCardAbility

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.DOUBLE

func execute(targets : TargetingInfo) -> void:
	var target_array: Array = targets.targets.duplicate()
	
	# If both targets are the same, hit them again
	if target_array[0] == target_array[1]:
		target_array.push_back(target_array[0])
		
	for target in target_array:
		var damage = Damage.new()
		damage.add_damage(3, COMMON_ENUMS.DAMAGE_TYPE.MAGIC)
		damage.source = BattleController.data.player
		damage.is_strike = true
		target.take_damage(damage)
