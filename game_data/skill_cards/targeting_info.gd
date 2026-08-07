class_name targeting_info
extends Resource

var targets : Array[int]

func add_target(idx : int):
	targets.append(idx)
func get_target(idx : int):
	if(idx < 0 || idx >= len(targets)):
		print("Invalid target idx")
		return -1
	return targets[idx]
func deal_damage(controller: battle_controller, idx : int, type: COMMON_ENUMS.DAMAGE_TYPE, damage: int):
	if(idx < 0 || idx >= len(targets)):
		print("Invalid target idx")
		return
	
	controller.data.enemies[targets[idx]].take_damage(type, damage)

func check_length(target_len : int):
	return len(targets) == target_len
