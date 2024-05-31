extends Node

@export var upgrades_pool: Array[AbilityUpgrade]
@export var experience_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}

func _ready():
	experience_manager.level_up.connect(on_level_up)

func on_level_up(current_level: int):
	var chosen_upgrade = upgrades_pool.pick_random() as AbilityUpgrade
	if chosen_upgrade == null:
		return
	var upgrade_screen_instance = upgrade_screen_scene.instantiate() as UpgradeScreen
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrades([chosen_upgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
	
func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] +=  1
	print(current_upgrades)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)

func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
