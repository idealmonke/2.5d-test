class_name vine_lash_ability
extends SkillCardAbility

var returned_card: SkillCard = null

func _init() -> void:
	target_type = COMMON_ENUMS.TARGET_TYPE.SINGLE
	
func execute(targets : TargetingInfo) -> void:
	var discard_size = BattleController.data.discard.discard.size()
	var out = await BattleController.maybe_manager_instance.maybe("Replenish a card: ", discard_size>0, true)
	
	var damage = Damage.new()
	damage.source = BattleController.data.player
	damage.is_strike = true
	
	if(out):
		BattleController.data.discard._custom_display_discard(return_card)
		await BattleController.display_signal
		BattleController.replenish_single(returned_card)
		returned_card = null
		
		damage.add_damage(8, COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
	else:
		damage.add_damage(4, COMMON_ENUMS.DAMAGE_TYPE.PHYSICAL)
	await targets.single_target().take_damage(damage)
	

func return_card(card: SkillCard) -> void:
	returned_card = card
		
