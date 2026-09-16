class_name targeting_info
extends RefCounted

enum POSITIONS {LEFT, MIDDLE, RIGHT}

var targets : Array[enemy]

func add_target(enem : enemy):
	targets.append(enem)
	
func single_target() -> enemy:
	return targets[0]
	
func all_targets() -> Array[enemy]:
	var enemies = []
	for enem in targets:
		enemies.append(enem)
	return enemies
		
# Deprecated?
func get_target(idx : int):
	if(idx < 0 || idx >= len(targets)):
		print("Invalid target idx")
		return -1
	return targets[idx]

func check_length(target_len : int):
	return len(targets) == target_len
