class_name targeting_info
extends RefCounted

enum POSITIONS {LEFT, MIDDLE, RIGHT}

var targets : Array[int]

func add_target(idx : int):
	targets.append(idx)
	
func single_target() -> enemy:
	return BattleController.data.enemies[targets[0]]
	
func all_targets() -> Array[enemy]:
	var enemies = []
	for position in targets:
		enemies.append(BattleController.data.enemies[position])
	return enemies
		
# Deprecated?
func get_target(idx : int):
	if(idx < 0 || idx >= len(targets)):
		print("Invalid target idx")
		return -1
	return targets[idx]

func check_length(target_len : int):
	return len(targets) == target_len
