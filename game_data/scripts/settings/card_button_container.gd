extends VBoxContainer

const card_editor_path : String = "../../../card_editor"
var card_data_editor : VBoxContainer
var card_editor_output : Label
var card_filter : TextEdit
var tab_container : TabContainer
var panel : PanelContainer

enum MODE {SKILL_CARD, ENEMY_CARD, ENEMY}
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
		_instantiate_button_helper(SkillCardRegistry, MODE.SKILL_CARD, filter)
	elif mode == MODE.ENEMY_CARD:
		_instantiate_button_helper(EnemyCardRegistry, MODE.ENEMY_CARD, filter)
	elif mode == MODE.ENEMY:
		_instantiate_button_helper(EnemyRegistry, MODE.ENEMY, filter)
	
func _instantiate_button_helper(registry: Variant, to_mode: MODE, filter: String) -> void:
	var DB : Dictionary
	if(to_mode == MODE.ENEMY):
		DB = registry.ENEMY_DB
	else:
		DB = registry.CARD_DB
	
	for id in DB:
		var data : Variant
		if(to_mode == MODE.ENEMY):
			data = registry.get_enemy_data(id)
		else:
			data = registry.get_card_data(id)
		
		if(not data):
			#print("BAD DATA AT ID: "+str(id)+" / MODE: "+str(to_mode))
			continue
		
		var cur_name : String = "placeholder"
		if(to_mode == MODE.ENEMY):
			cur_name = data.enemy_name
		else:
			cur_name = data.card_name
		
		if(not filter=="" and not(cur_name.to_lower().contains(filter))):
			continue
		
		_create_button(id, to_mode, cur_name)

func _create_button(id: int, to_mode: MODE, cur_name : String) -> void:
	var button: Button = Button.new()
	button.text = str(id)+": "+cur_name
	get_node("margin_container/inner_container").add_child(button)
	button.pressed.connect(_on_pressed.bind(id,to_mode))

func _on_pressed(id : int, to_mode: MODE) -> void:
	card_data_editor.display(id, to_mode)
	card_editor_output.text = ""
	panel.visible = true

func _on_filter_text_changed() -> void:
	reset_buttons()
