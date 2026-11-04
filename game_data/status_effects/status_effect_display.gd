class_name StatusEffectDisplay
extends FlowContainer

signal effect_hovered(effect)
signal effect_unhovered(effect)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func setup(min_width: int):
	custom_minimum_size.x = min_width

func reset(status_effects : Dictionary[String, StatusEffect]):
	_reset_children()
	for effect in status_effects:
		_add_effect(status_effects[effect])

func _add_effect(effect : StatusEffect):
	var data : StatusEffectData = effect.data
	
	var item = Control.new()
	item.custom_minimum_size = Vector2(48, 48)
	
	var image := TextureRect.new()
	image.texture = data.display_image
	image.mouse_filter = Control.MOUSE_FILTER_PASS
	image.set_meta("status", effect) 
	image.tooltip_text = effect.data.desc
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
