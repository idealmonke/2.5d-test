extends VBoxContainer

const card_editor_path : String = "../../../card_editor"
var card_data_editor : VBoxContainer
var card_editor_output : Label
var card_filter : TextEdit
var tab_container : TabContainer
var panel : PanelContainer

enum MODE {SKILL_CARD, ENEMY_CARD}
var mode : int = MODE.SKILL_CARD

func _ready() -> void:
	var card_editor : Control = get_node(card_editor_path)
	
	card_data_editor = card_editor.get_node("card_data_editor_panel/margin_container/card_data_editor_container/card_data_editor")
	card_editor_output = card_editor.get_node("card_editor_output")
	card_filter = card_editor.get_node("filter")
	tab_container = card_editor.get_node("../tab_container")
	panel = card_editor.get_node("card_data_editor_panel")
	
	card_data_editor.init()
	tab_container.init()
	
	#reset_buttons()
	#card_data_editor.display(1001, true)

func reset_to_mode(new_mode : MODE):
	mode = new_mode
	panel.visible = false
	reset_buttons()
	card_data_editor.reset()
	card_editor_output.text = ""

func reset_buttons() -> void:
	_instantiate_buttons(card_filter.text)

func _instantiate_buttons(filter: String) -> void:
	for child in get_node("margin_container/inner_container").get_children():
		child.queue_free()
	
	filter = filter.to_lower()
	
	if mode == MODE.SKILL_CARD:
		_instantiate_button_helper(skill_card_registry, MODE.SKILL_CARD, filter)
	elif mode == MODE.ENEMY_CARD:
		_instantiate_button_helper(enemy_card_registry, MODE.ENEMY_CARD, filter)

func _instantiate_button_helper(registry: Variant, mode: MODE, filter: String) -> void:
	for id in registry.CARD_DB:
		var data : Variant = registry.get_card_data(id)
		
		if(not filter=="" and not(data.card_name.to_lower().contains(filter))):
			continue
		
		_create_button(id, mode, data.card_name)

func _create_button(id: int, mode: MODE, name : String) -> void:
	#var center = CenterContainer.new()
	
	var button: Button = Button.new()
	button.text = str(id)+": "+name
	#center.add_child(button)
	get_node("margin_container/inner_container").add_child(button)
	button.pressed.connect(_on_pressed.bind(id,mode))

func _on_pressed(id : int, mode: MODE) -> void:
	card_data_editor.display(id, mode)
	card_editor_output.text = ""
	panel.visible = true

func _on_filter_text_changed() -> void:
	reset_buttons()
