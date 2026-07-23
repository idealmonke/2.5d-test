extends VBoxContainer

var skill_card_editor: VBoxContainer

const skill_card_editor_source = "../../skill_card_editor"
const skill_card_output_source = "../../skill_card_editor_output"
const skill_card_filter_source = "../../filter"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skill_card_editor = get_node(skill_card_editor_source)
	reset_buttons()
	
	skill_card_editor.display(1001)

"""
func load_resources() -> void:
#	var files = DirAccess.get_files_at("res://game_data/skill_cards/skill_cards_data")
	for file_name in files:
		var cur_data = load("res://game_data/skill_cards/skill_cards_data/"+file_name)
		data.append(cur_data)

func instantiate() -> void:
	for i in range(len(data)):
		var cur_data = data[i]
		
		var button: Button = Button.new()
		button.text = cur_data.card_name
		add_child(button)
		button.pressed.connect(_on_pressed.bind(i))
"""

func reset_buttons() -> void:
	instantiate_buttons(get_node(skill_card_filter_source).text)

func instantiate_buttons(filter: String) -> void:
	for child in get_children():
		child.queue_free()
	
	filter = filter.to_lower()
	for id in skill_card_registry.CARD_DB:
		var data = skill_card_registry.get_card_data(id)
		
		if(not filter=="" and not(data.card_name.to_lower().contains(filter))):
			continue
		
		var button: Button = Button.new()
		button.text = str(id)+": "+data.card_name
		add_child(button)
		button.pressed.connect(_on_pressed.bind(id))

func _on_pressed(id) -> void:
	skill_card_editor.display(id)
	var output = get_node(skill_card_output_source)
	output.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_filter_text_changed() -> void:
	reset_buttons()
