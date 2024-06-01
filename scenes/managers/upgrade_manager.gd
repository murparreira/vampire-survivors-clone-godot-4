extends Node

@export var upgrades_pool: Array[AbilityUpgrade]
@export var experience_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}

func _ready():
	experience_manager.level_up.connect(on_level_up)
	
func apply_upgrade(upgrade: ):
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] +=  1
	print(current_upgrades)
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrades_pool = upgrades_pool.filter(func (poll_upgrade): return poll_upgrade.id != upgrade.id)
			
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)

func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	var filtered_upgrades = upgrades_pool.duplicate()
	for i in 2:
		if filtered_upgrades.size() == 0:
			break
		var chosen_upgrade = filtered_upgrades.pick_random() as AbilityUpgrade
		chosen_upgrades.append(chosen_upgrade)
		filtered_upgrades = filtered_upgrades.filter(func (upgrade): return upgrade.id != chosen_upgrade.id)
	
	return chosen_upgrades

func on_level_up(current_level: int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate() as UpgradeScreen
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades)
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)

func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
