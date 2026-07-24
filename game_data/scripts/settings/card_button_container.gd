extends VBoxContainer

var card_data_editor : VBoxContainer
var card_editor_output : Label
var card_filter : TextEdit

var is_skill_card : bool = true

func _ready() -> void:
	card_data_editor = get_node("../../card_data_editor")
	card_editor_output = get_node("../../card_editor_output")
	card_filter = get_node("../../filter")
	
	card_data_editor.init()
	
	reset_buttons()
	card_data_editor.display(1001, true)

func reset_buttons() -> void:
	_instantiate_buttons(card_filter.text)

func _instantiate_buttons(filter: String) -> void:
	for child in get_children():
		child.queue_free()
	
	filter = filter.to_lower()
	
	if is_skill_card:
		_instantiate_button_helper(skill_card_registry, true, filter)
	else:
		_instantiate_button_helper(enemy_card_registry, false, filter)

func _instantiate_button_helper(registry: Variant, is_skill_card: bool, filter: String) -> void:
	for id in registry.CARD_DB:
		var data : Variant = registry.get_card_data(id)
		
		if(not filter=="" and not(data.card_name.to_lower().contains(filter))):
			continue
		
		_create_button(id, is_skill_card, data.card_name)

func _create_button(id: int, is_skill_card: bool, name : String) -> void:
	var button: Button = Button.new()
	button.text = str(id)+": "+name
	add_child(button)
	button.pressed.connect(_on_pressed.bind(id,is_skill_card))

func _on_pressed(id : int, is_skill_card: bool) -> void:
	card_data_editor.display(id, is_skill_card)
	card_editor_output.text = ""

func _on_filter_text_changed() -> void:
	reset_buttons()
