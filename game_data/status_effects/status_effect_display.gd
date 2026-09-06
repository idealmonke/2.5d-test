class_name status_effect_display
extends FlowContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#setup(200)
	#var status = status_effect.new(status_effect_registry.get_status_effect_data(1001))
	#status.stacks = 5
	#_add_effect(status)
	#_add_effect(status)
	#_add_effect(status)
	#_add_effect(status)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup(min_width: int):
	custom_minimum_size.x = min_width

func reset(status_effects : Dictionary[String, status_effect]):
	_reset_children()
	for effect in status_effects:
		_add_effect(status_effects[effect])

func _add_effect(effect : status_effect):
	var data : status_effect_data = effect.data
	
	var item = Control.new()
	item.custom_minimum_size = Vector2(64, 64)
	
	var image := TextureRect.new()
	image.texture = data.display_image
	image.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	item.add_child(image)
	
	var label := Label.new()
	label.text = str(effect.stacks)
	item.add_child(label)
	
	add_child(item)
	
func _reset_children():
	for child in get_children():
		child.queue_free()
