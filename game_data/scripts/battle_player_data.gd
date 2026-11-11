class_name BattlePlayerData
extends Entity

var character_classes: Array[COMMON_ENUMS.CHARACTER_CLASSES]
var camera: Camera2D
var screen_flash: ColorRect
var flash_tween: Tween

func init_bars(hp_bar, hp_label, m_bar, m_label, s_bar, s_label, status_bars) -> void:
	health_bar = hp_bar
	health_bar_text = hp_label
	health_bar.max_value = max_health
	
	mana_bar = m_bar
	mana_bar_text = m_label
	mana_bar.max_value = max_mana
	
	stamina_bar = s_bar
	stamina_bar_text = s_label
	stamina_bar.max_value = max_stamina
	
	status_effect_bar = status_bars
	
	_update_stat_bars()

func process_statuses(timing: COMMON_ENUMS.TIMING) -> void:
	await _process_active_status(timing)
	update_passive_effects()
	_process_status_stacks()
	_update_status()
	
func damage_animation(health_array: Array, shield_array: Array, missed: bool = false):
	var flash
	var shake
	if !missed:
		flash = damage_flash(Color(1, 0.3, 0.3), screen_flash)
		shake = shake(camera)
	else:
		flash = damage_flash(Color(1.0, 1.0, 1.0, 0.5), screen_flash)
		shake = null
		effect_text("MISSED!", Color.WHITE, 120)
	if flash and flash.is_running():
		await flash.finished
	if shake and shake.is_running():
		await shake.finished
	
func animation_setup(camera: Camera2D, screen_flash: ColorRect):
	self.camera = camera
	self.screen_flash = screen_flash

func damage_flash(color: Color, target: Variant) -> Tween:
	var end_color: Color = Color(color)
	end_color.a = 0
	if flash_tween and flash_tween.is_running():
		flash_tween.kill()
	flash_tween = target.create_tween()
	target.color = color
	flash_tween.tween_property(target, "color", end_color, 0.25)
	return flash_tween
