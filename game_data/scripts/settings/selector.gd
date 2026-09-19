extends HBoxContainer

const battle_config_path = "res://game_data/battle_config.tres"
var idx_to_id : Dictionary
var config : BattleConfig

func _ready() -> void:
	config = load(battle_config_path)
	var enemies = config.enemyIDs
	
	for i in range(3):
		var vbox : VBoxContainer = VBoxContainer.new()
		var label : Label = Label.new()
		label.text = "Enemy #"+str(i+1)+":"
		var option : OptionButton = OptionButton.new()
		
		option.add_item("Empty")
		_add_enemies(option, enemies[i])
		option.item_selected.connect(_on_selected.bind(i))
		
		vbox.add_child(label)
		vbox.add_child(option)
		
		add_child(vbox)

func _on_selected(option_idx: int, enemy_idx: int) -> void:
	if(option_idx == 0):
		config.enemyIDs[enemy_idx] = -1
	else:
		config.enemyIDs[enemy_idx] = idx_to_id[option_idx]
	ResourceSaver.save(config, battle_config_path)
	

func _add_enemies(button : OptionButton, cur_id: int):
	var registry : Dictionary = EnemyRegistry.ENEMY_DB
	var cur_idx : int = 1
	
	for id in registry:
		if id not in idx_to_id:
			idx_to_id[cur_idx] = id
		
		button.add_item(str(id)+": "+registry.get(id))
		if(id == cur_id):
			button.select(cur_idx)
		cur_idx += 1
