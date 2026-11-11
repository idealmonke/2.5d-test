class_name SkillCard
extends Area2D

# Card Details
var card_name: String
var card_id: int
var card_art: Texture2D
var stamina_cost: int
var mana_cost: int
var ability_desc: String
var ability: SkillCardAbility
var classes: Array[COMMON_ENUMS.CHARACTER_CLASSES]

# Card Sprites
var card_main_frame: Sprite2D
@export var art_size: int = 150

# Child Node References
var card_name_label: Label
var card_ability_label: Label
var card_mana_cost_label: Label
var card_stamina_cost_label: Label
var card_sprite : Sprite2D

# Card Control Data
var interactable_state: COMMON_ENUMS.INTERACT_STATE:
	set(value):
		interactable_state = value
		_update_pickable()
var drag_offset: Vector2
var location_offset: Vector2
var rotation_offset: float
var hand_location: Vector2
var discard_location: Vector2
var library_location: Vector2
var misc_location: Vector2
@export var quick_lerp: int = 40
@export var slow_lerp: int = 20
@export var rotate_lerp: int = 12
var prev_state: COMMON_ENUMS.INTERACT_STATE

# Animation Variables
var target_rotation: float
var hover_offset: Vector2 = Vector2.ZERO
var old_position: Vector2
var old_tilt: float = 0.0
var screen_size: Vector2
var exhaust_material: ShaderMaterial
var tween_scale: Tween
var base_scale: Vector2
var pos_tween: Tween

var base_z_index : int
var z_index_modifier: int
var z_index_hover: int

var hover : bool
var audio_played: bool = false

var discard_castable: COMMON_ENUMS.DISCARD_CASTABLE_MODES

# Card State
var exhausted: bool:
	set(value):
		exhausted = value
		exhaust_material.set_shader_parameter("is_exhausted", exhausted)
				
# Subscribers
var select_subscribers: Dictionary

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size
	base_scale = scale
	
	# TEMPORARY VARIABLES
	hand_location = Vector2(screen_size.x / 2.0, screen_size.y - 150)
	#discard_location = Vector2(200,screen_size.y - 200)
	#library_location = Vector2(screen_size.x - 200,200)
	
	connect("input_event", _on_input_event)
	$hover_area.connect("mouse_entered", _on_mouse_entered)
	$hover_area.connect("mouse_exited", _on_mouse_exited)
	
	card_main_frame = $Sprite2D
	exhaust_material = ShaderMaterial.new() 
	exhaust_material.shader = load("res://game_data/skill_cards/card_art/exhausted_card.gdshader")
	card_main_frame.material = exhaust_material
	
	card_name_label = $Sprite2D/card_name
	card_ability_label = $Sprite2D/card_ability
	card_mana_cost_label = $Sprite2D/mana_cost
	card_stamina_cost_label = $Sprite2D/stamina_cost
	
	card_sprite = $Sprite2D/CardArt
	_update_text()
	
	interactable_state = COMMON_ENUMS.INTERACT_STATE.LIBRARY
	set_back()

func set_locs(library: Node2D, discard: Area2D):
	library_location = library.get_node("base_sprite").position+Vector2(0,0)
	discard_location = discard.position+Vector2(0,0)
	
func _process(delta: float) -> void:
	z_index = base_z_index + z_index_modifier + z_index_hover
	
	match interactable_state:
		COMMON_ENUMS.INTERACT_STATE.DRAGGING:
			var target = get_global_mouse_position() + drag_offset
			global_position = global_position.lerp(target, quick_lerp  * delta)
			rotation = lerp_angle(rotation, target_rotation, rotate_lerp * delta)
		COMMON_ENUMS.INTERACT_STATE.HAND:
			var target = hand_location + location_offset + hover_offset
			if global_position.distance_to(target) > 1:
				global_position = global_position.lerp(target, slow_lerp * delta)
			else:
				global_position = target
			rotation = lerp_angle(rotation, rotation_offset, rotate_lerp * delta)
		COMMON_ENUMS.INTERACT_STATE.LIBRARY:
			if global_position.distance_to(library_location) > 1:
				global_position = global_position.lerp(library_location, slow_lerp * delta)
			else:
				global_position = library_location
		COMMON_ENUMS.INTERACT_STATE.DISCARD:
			if global_position.distance_to(discard_location) > 1:
				global_position = global_position.lerp(discard_location, slow_lerp * delta)
			else:
				global_position = discard_location
		COMMON_ENUMS.INTERACT_STATE.GRID_DISPLAY:
			if global_position.distance_to(misc_location) > 1:
				global_position = global_position.lerp(misc_location, slow_lerp * delta)
			else:
				global_position = misc_location
		COMMON_ENUMS.INTERACT_STATE.PLAYING:
			var target = (screen_size/2) 
			if BattleController.current_state == COMMON_ENUMS.BATTLE_STATE.DISPLAYING:
				target += Vector2(0, 1000)
				
			if global_position.distance_to(target) > 1:
				global_position = global_position.lerp(target, slow_lerp * delta)
			else:
				global_position = target
			
func initialize_card(resource_data: SkillCardData) -> void:
	card_name = resource_data.card_name
	card_id = resource_data.card_id
	stamina_cost = resource_data.stamina_cost
	mana_cost = resource_data.mana_cost
	ability_desc = resource_data.ability_desc
	ability = resource_data.card_ability
	discard_castable = resource_data.discard_castable
	
	card_art = resource_data.card_art
	
	if card_art:
		card_sprite.texture = card_art
		var target_size = Vector2(250,250)
		var texture_size = card_sprite.texture.get_size()
		card_sprite.scale = target_size / texture_size
	
	classes = resource_data.card_classes
	
	_update_text()
	
func begin_drag() -> void:
	if interactable_state != COMMON_ENUMS.INTERACT_STATE.DRAGGING:
		prev_state = interactable_state
	interactable_state = COMMON_ENUMS.INTERACT_STATE.DRAGGING
	self.old_tilt = self.target_rotation
	self.target_rotation = 0.0
	drag_offset = global_position - get_global_mouse_position()
	
func set_back() -> void:
	card_main_frame.texture = load("res://game_data/card_frames/Back_Skill.png")
	card_name_label.hide()
	card_mana_cost_label.hide()
	card_stamina_cost_label.hide()
	card_ability_label.hide()
	$Sprite2D.self_modulate = Color.WHITE
	$Sprite2D/Symbols.visible = false

func mute_color(color: Color, amount: float = 0.3) -> Color:
	return color.lerp(Color(255,255,255), amount)
	
func set_front() -> void:
	card_main_frame.texture = load("res://game_data/card_frames/Front_Card.png")
	card_name_label.show()
	card_mana_cost_label.show()
	card_stamina_cost_label.show()
	card_ability_label.show()
	$Sprite2D/Symbols.visible = true
	if classes:
		var cur_class = classes[0]
		if(cur_class):
			$Sprite2D.self_modulate = COMMON_ENUMS.CLASS_COLORS[cur_class].lightened(0.25)

func set_exhausted(value: bool) -> void:
	exhausted = value
	
func set_input_pickable(value: bool) -> void:
	input_pickable = value
	
func add_select_subscriber(subscriber: Callable, key: String) -> void:
	select_subscribers[key] = subscriber
	
func remove_select_subscriber(key: String) -> void:
	select_subscribers.erase(key)
	
func _report_select() -> void:
	for subscriber in select_subscribers.values():
		subscriber.call(self)

func _update_text() -> void:
	card_name_label.text = card_name
	card_ability_label.text = ability_desc
	card_stamina_cost_label.text = str(stamina_cost)
	card_mana_cost_label.text = str(mana_cost)
	
	
	
## Handles Mouse Down Presses
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if BattleController.current_state == COMMON_ENUMS.BATTLE_STATE.PLAYER_PLAYING and event.pressed:
				BattleController.data.hand.register_pickup(self)
				return
			if BattleController.current_state == COMMON_ENUMS.BATTLE_STATE.DISPLAYING and event.pressed:
				_report_select()
				return

func _input(event: InputEvent) -> void:
	if (interactable_state == COMMON_ENUMS.INTERACT_STATE.DRAGGING) && (BattleController.current_state == COMMON_ENUMS.BATTLE_STATE.PLAYER_PLAYING) && (self.position.y <= screen_size.y/2):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
				if BattleController.data.player.get_stamina() >= self.stamina_cost && BattleController.data.player.get_mana() >= self.mana_cost:
					BattleController.play_card(self)
				else:
					interactable_state = prev_state
					self.target_rotation = old_tilt
					
	elif interactable_state == COMMON_ENUMS.INTERACT_STATE.DRAGGING:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
				interactable_state = prev_state
				self.target_rotation = old_tilt


func _on_mouse_entered() -> void:
	BattleController.data.hand.subscribe(self)
	#if !hover:
		#if self.interactable_state == COMMON_ENUMS.INTERACT_STATE.HAND || self.interactable_state == COMMON_ENUMS.INTERACT_STATE.GRID_DISPLAY || self.interactable_state == COMMON_ENUMS.INTERACT_STATE.PLAYING:
			#AudioManager.play_audio('Click')
			#BattleController.tooltip_manager_instance.hover_card(self)
#
		#player_highlight_card()
	#hover = true
	pass
	
func _on_mouse_exited() -> void:
	BattleController.data.hand.unsubscribe(self)
	#
	#if hover:
		#player_unhighlight_card()
		#BattleController.tooltip_manager_instance.unhover_card(self)
	#hover = false
	pass
	

func _update_pickable() -> void:
	if interactable_state == COMMON_ENUMS.INTERACT_STATE.HAND or interactable_state == COMMON_ENUMS.INTERACT_STATE.GRID_DISPLAY:
		set_input_pickable(true)
	else:
		set_input_pickable(false)

func player_highlight_card() -> void:
	z_index_hover = 5
	if tween_scale:
		tween_scale.kill()
	tween_scale = create_tween()
	tween_scale.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween_scale.tween_property(self, "scale", base_scale * 1.2, 0.15)
	pos_tween = $Sprite2D.create_tween()
	pos_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	pos_tween.tween_property($Sprite2D, "position", Vector2(0,-50), 0.15)

func player_unhighlight_card() -> void:
	audio_played = false
	z_index_hover = -5
	hover_offset = Vector2(0,0)
	if tween_scale:
		tween_scale.kill()
	tween_scale = create_tween()
	tween_scale.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween_scale.tween_property(self, "scale", base_scale, 0.15)
	pos_tween = $Sprite2D.create_tween()
	pos_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	pos_tween.tween_property($Sprite2D, "position", Vector2(0,0), 0.15)
