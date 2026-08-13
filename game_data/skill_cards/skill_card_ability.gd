class_name skill_card_ability
extends Resource

enum POSITIONS {LEFT, MIDDLE, RIGHT}

#@export_enum("NONE", "SINGLE") var target_type: int
var target_type = COMMON_ENUMS.TARGET_TYPE.NONE

# Targets go into array in order chosen, index 0 is first target and so on
func execute(targets : targeting_info) -> void:
	print(targets)
	
