extends TabContainer

const card_editor_path : String = "../card_editor"
var card_editor : Control
var card_button_container : VBoxContainer
var mode_display : Label

enum MODE {SKILL_CARD, ENEMY_CARD}

func _ready() -> void:
	pass

func init() -> void:
	card_editor = get_node(card_editor_path)
	card_button_container = card_editor.get_node("card_button_scroll_container/card_button_container")
	mode_display = card_editor.get_node("mode_display")
	_swap_to(current_tab)

func _swap_to(tab: int) -> void:
	if tab == 0:
		card_editor.visible = false
	else:
		card_editor.visible = true
		if tab == 1:
			mode_display.text = "Current Skill Cards:"
			card_button_container.reset_to_mode(MODE.SKILL_CARD)
		if tab == 2:
			mode_display.text = "Current Enemy Cards:"
			card_button_container.reset_to_mode(MODE.ENEMY_CARD)

func _on_tab_changed(tab: int) -> void:
	_swap_to(tab)
