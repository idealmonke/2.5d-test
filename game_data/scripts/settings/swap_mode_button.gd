extends Button

var mode_display : Label
var card_button_container : VBoxContainer
var is_skill_card : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mode_display = get_node("../mode_display")
	card_button_container = get_node("../../card_button_scroll_container/card_button_container")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	if is_skill_card:
		mode_display.text = "Current Enemy Cards:"
	else:
		mode_display.text = "Current Skill Cards:"
	is_skill_card = not(is_skill_card)
	
	card_button_container.is_skill_card = is_skill_card
	card_button_container.reset_buttons()
	
