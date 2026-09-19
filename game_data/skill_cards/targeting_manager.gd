class_name TargetingManager
extends Node2D

var _targeting : bool = false

var _cur_arrow : Line2D
var _placed_arrows : Array[Line2D]
var _arrow_head : Sprite2D
var _placed_arrowheads : Array[Sprite2D]

var arrow_head_texture = preload("res://game_data/arrowhead.png")

var res : Enemy

var OFFSETS : Array[int]

var cur_card : SkillCard
var cur_type : COMMON_ENUMS.TARGET_TYPE

var cancel_button : Button
var confirm_button : Button

var cur_targets : TargetingInfo

func _ready() -> void:
	_placed_arrows = []
	_placed_arrowheads = []
	OFFSETS = [0,0,0]
	
	cancel_button = $cancel_button
	confirm_button = $confirm_button

signal targeting_finished(targets: TargetingInfo)

func select_targets(card: SkillCard) -> TargetingInfo:
	_targeting = true
	cur_card = card
	cur_type = card.ability.target_type
	
	cur_targets = TargetingInfo.new()
	
	cancel_button.visible = true
	#confirm_button.visible = true
	
	_create_arrow()
	
	#targeting UI
	#player inputs
	return await targeting_finished

func _get_color() -> Color:
	var hue = float(len(_placed_arrows))/9.0
	return Color.from_hsv(hue, 0.45, 0.9)

func _create_arrow():
	_cur_arrow = Line2D.new()
	add_child(_cur_arrow)
	_cur_arrow.width = 8
	_cur_arrow.default_color = _get_color()
	
	_arrow_head = Sprite2D.new()
	_arrow_head.texture = arrow_head_texture
	add_child(_arrow_head)
	
	check_targets()

func _process(_delta: float) -> void:
	res = get_enemy_under_mouse()
	
	if _cur_arrow and _arrow_head:
		if(res and _targeting):
			_cur_arrow.visible = true
			_arrow_head.visible = true
		else:
			_cur_arrow.visible = false
			_arrow_head.visible = false
	
	if _targeting and res:
		_display_arrow()

func _display_arrow():
	var screen_size = get_viewport().get_visible_rect().size
	var start = (screen_size/2)
	#var end = get_global_mouse_position()
	var end = BattleController.data.enemy_locations[res.idx]
	
	_cur_arrow.clear_points()
	
	var midpoint = (start + end) * 0.5
	
	var bend = clamp(start.distance_to(end)*0.25,50,200)
	var control = midpoint + Vector2(0,-bend) + Vector2(0,-OFFSETS[res.idx])
	if res.idx==1:
		control = midpoint + Vector2(0,-bend) + Vector2(OFFSETS[res.idx],0)
	
	var store : Vector2
	
	for i in range(30):
		_cur_arrow.add_point(bezier(start,control,end,float(i)/30))
		
		if(i==28):
			store = bezier(start,control,end,float(i)/30)
	
	_arrow_head.scale = Vector2(0.2,0.2)
	_arrow_head.global_position = store
	
	var init = 0.9
	var change = 0.05
	_arrow_head.rotation = (bezier(start,control,end,init) - bezier(start,control, end, init-change)).normalized().angle()

func _input(event):
	if not res or not _targeting:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_placed_arrows.append(_cur_arrow)
			_placed_arrowheads.append(_arrow_head)
			
			cur_targets.add_target(res)
			
			_create_arrow()
			OFFSETS[res.idx] += 100

func check_targets():
	var done = false
	
	if(cur_type == COMMON_ENUMS.TARGET_TYPE.NONE):
		done = true
	if(cur_type == COMMON_ENUMS.TARGET_TYPE.SINGLE):
		if cur_targets.check_length(1):
			done = true
	if(cur_type == COMMON_ENUMS.TARGET_TYPE.DOUBLE):
		if cur_targets.check_length(2):
			done = true
	
	if(done):
		confirm_button.visible = true
		_targeting = false

func _reset():
	for arrow in _placed_arrows:
		arrow.queue_free()
	_cur_arrow.queue_free()
	_placed_arrows.clear()
	
	for arrow_head in _placed_arrowheads:
		arrow_head.queue_free()
	_arrow_head.queue_free()
	_placed_arrowheads.clear()
	
	cancel_button.visible = false
	confirm_button.visible = false
	
	_targeting = false

func get_enemy_under_mouse():
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collision_mask = 1
	query.collide_with_areas = true
	
	var results = get_world_2d().direct_space_state.intersect_point(query)
	for result in results:
		if result.collider is Enemy:
			return result.collider

func bezier(start: Vector2, control: Vector2, end: Vector2, t: float) -> Vector2:
	var p1 = start.lerp(control,t)
	var p2 = control.lerp(end,t)
	return p1.lerp(p2,t)


func _on_confirm_button_pressed() -> void:
	_reset()
	targeting_finished.emit(cur_targets)


func _on_cancel_button_pressed() -> void:
	_reset()
	targeting_finished.emit(null)
