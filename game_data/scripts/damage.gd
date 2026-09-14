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
		if status.data.status_type == COMMON_ENUMS.STATUS_TYPE.PASSIVE && status.data.stat_affected == COMMON_ENUMS.PLAYER_STATS.OUTGOING_DAMAGE:
			self.modify_all_damage(status.data.calculation.calculate)

## Returns amount of damage done to shield, and decrements values within the object
func damage_shield(shield: int, defense: Dictionary[COMMON_ENUMS.DAMAGE_TYPE, int]) -> int:
	
	var total_damage_applied: int = 0
	for key in self.damages:
		var base_max_damage = damages.get(key)
		
		# Performance check, go next if max is not enough to break shield
		var max_calculated_damage = base_max_damage
		for equation in shield_multipliers:
			max_calculated_damage = equation.call(max_calculated_damage)
			
		if max_calculated_damage + total_damage_applied > shield:
			var remaining_shield = shield - total_damage_applied
			var min_damage = _binary_search_min_damage(shield)
			
			for equation in shield_multipliers:
				min_damage = equation.call(min_damage)
				
			damages[key] -= min_damage
			break
						
		else:
			total_damage_applied += max_calculated_damage
			damages.erase(key)
	
	return total_damage_applied
	
## Returns amount of damage done to health, and decrements values within the object
func damage_health(defense: Dictionary[COMMON_ENUMS.DAMAGE_TYPE, int]) -> int:
	var total_damage_applied: int = 0
	
	for key in self.damages:
		var base_damage = damages[key]
		var calculated_damage = base_damage
		
		for equation in health_multipliers:
			calculated_damage = equation.call(calculated_damage)
		
		total_damage_applied += calculated_damage
	
	damages.clear()
	return total_damage_applied
	
func _binary_search_min_damage(shield_hp: int) -> int:
	var low: int = 0
	var high: int = shield_hp * 2
	
	while low < high:
		var mid: int = (low + high) / 2
		var calculated_damage: int = mid
		
		# Apply all modifiers in timestamp order
		for equation in shield_multipliers:
			calculated_damage = equation.call(calculated_damage)
		
		if calculated_damage < shield_hp:
			low = mid + 1  # Always increment to prevent infinite loop
		else:
			high = mid
	
	return low
