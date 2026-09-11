class_name Damage
extends RefCounted

var damages: Dictionary[COMMON_ENUMS.DAMAGE_TYPE, int]

var damage_type: COMMON_ENUMS.DAMAGE_TYPE
var amount: int
var source: Variant

var is_strike: bool = false

var shield_multipliers: Array[Callable] = []
var health_multipliers: Array[Callable] = []

func add_damage(amount: int, type: COMMON_ENUMS.DAMAGE_TYPE):
	if damages.has(type):
		damages.set(type, damages.get(type) + amount)
	else:
		damages.set(type, amount)
	
func modify_all_damage(calculation: Callable):
	for key in damages:
		damages.set(key, calculation.call(damages.get(key)))
	
func modifiy_damage_type(calculation: Callable, type: COMMON_ENUMS.DAMAGE_TYPE):
	if damages.has(type):
		damages.set(type, calculation.call(damages.get(type)))

# Checks if a player status adds to the outgoing damage
func outgoing_update() -> void:
	var cur_status = source.current_status_effects
	for key in cur_status:
		var status: status_effect = cur_status.get(key)
		if status.data.status_type == COMMON_ENUMS.STATUS_TYPE.PASSIVE && status.data.stat_affected == COMMON_ENUMS.PLAYER_STATS.DAMAGE:
			self.modify_all_damage(status.data.calculation.calculate)

func damage_shield(shield: int, defense: Dictionary[COMMON_ENUMS.DAMAGE_TYPE, int]) -> int:
	var total_damage_applied: int = 0
	for key in self.damages:
		var individual_type: int = self.damages.get(key)
		var def = defense.get(key)
		if def == null:
			def = 0
		individual_type -= def
		if individual_type > 0:
			total_damage_applied += individual_type
	return 0
	
func damage_health(defense: Dictionary[COMMON_ENUMS.DAMAGE_TYPE, int]) -> int:
	return 0
