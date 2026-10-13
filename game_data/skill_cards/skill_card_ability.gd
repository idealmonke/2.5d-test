class_name SkillCardAbility
extends Resource

enum POSITIONS {LEFT, MIDDLE, RIGHT}

#@export_enum("NONE", "SINGLE") var target_type: int
var target_type = COMMON_ENUMS.TARGET_TYPE.NONE
var target_flag = COMMON_ENUMS.TARGET_FLAG.NONE

# Targets go into array in order chosen, index 0 is first target and so on
func execute(targets : TargetingInfo) -> void:
	print(targets)
	
