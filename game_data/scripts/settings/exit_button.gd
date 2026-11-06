extends Button

@export var party_selector : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _swap() -> void:
	get_tree().change_scene_to_file("res://game_data/scenes/Main_Menu.tscn");

func _on_pressed() -> void:
	if(party_selector.unsaved_changes()):
		var out = await party_selector.maybe_manager_instance.maybe("You have unsaved changes, are you sure you want to exit? ", true, true)
		if out:
			_swap()
	else:
		_swap()
