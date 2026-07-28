class_name skill_card_display_grid
extends Node2D

var cards: Array[skill_card]
var exit_func: Callable
var screen_size: Vector2 
var starting_grid: Vector2 = Vector2.ZERO
var max_grid_width: int
var max_grid_height: int

@export var card_width: int = 200
@export var card_height: int = 250
@export var max_display_width: int = 1600
@export var separation_width: int = 50
@export var separation_height: int = 50

var old_state: COMMON_ENUMS.INTERACT_STATE

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size

func load_cards(payload: Array[skill_card], exit: Callable, text: String) -> void:
	cards.append_array(payload)
	exit_func = exit
	for card in payload:
		card.add_select_subscriber(_select_card, "display_grid")
		old_state = card.interactable_state
		card.interactable_state = COMMON_ENUMS.INTERACT_STATE.GRID_DISPLAY
		card.z_index += 10
	_calculate_grid()

func _select_card(card: skill_card):
	_clear_cards()
	exit_func.call(card)

func _clear_cards() -> void:
	for card in cards:
		card.remove_select_subscriber("display_grid")
		card.interactable_state = old_state
		card.z_index -= 10
	cards.clear()

func _calculate_grid() -> void:
	var cards_per_row: int = max_display_width / (card_width + separation_width)
	var layers: Array[Array] = []
	layers.resize(int(ceil(float(cards.size()) / cards_per_row)))

	for index in range(layers.size()):
		layers[index] = []
		layers[index].append_array(cards.slice(index * cards_per_row, (index + 1) * cards_per_row))

	var total_height: float = layers.size() * (card_height + separation_height) - separation_height
	var y_offset: float = (screen_size.y - total_height) / 2.0

	for layer_index in range(layers.size()):
		var layer = layers[layer_index]
		var total_width: float = layer.size() * (card_width + separation_width) - separation_width
		var x_offset: float = (screen_size.x - total_width) / 2.0
		for card_index in range(layer.size()):
			layer[card_index].misc_location.x = x_offset + card_index * (card_width + separation_width)
			layer[card_index].misc_location.y = y_offset + layer_index * (card_height + separation_height)
