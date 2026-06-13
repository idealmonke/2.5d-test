class_name skill_card_discard
extends Node

var discard: Array[skill_card] = []
	
func remove_all_cards() -> Array:
	var temp = discard
	discard = Array()
	return temp
	
func get_size() -> int:
	return discard.size()
