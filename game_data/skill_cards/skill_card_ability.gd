class_name skill_card_ability
extends Resource

# Targets go into array in order chosen, index 0 is first target and so on
func execute(controller: battle_controller, targets: Array, base_values: Dictionary) -> void:
	print(controller)
	print(targets)
	pass
