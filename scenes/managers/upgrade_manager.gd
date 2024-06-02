extends Node

@export var experience_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

var upgrade_giantaxe = preload("res://resources/upgrades/giantaxe.tres")
var upgrade_giantaxe_damage = preload("res://resources/upgrades/giantaxe_damage.tres")
var upgrade_longsword_rate = preload("res://resources/upgrades/longsword_rate.tres")
var upgrade_longsword_damage = preload("res://resources/upgrades/longsword_damage.tres")
var upgrade_player_speed = preload("res://resources/upgrades/player_speed.tres")

func _ready():
	upgrade_pool.add_item(upgrade_giantaxe, 10)
	upgrade_pool.add_item(upgrade_longsword_rate, 10)
	upgrade_pool.add_item(upgrade_longsword_damage, 10)
	upgrade_pool.add_item(upgrade_player_speed, 5)
	experience_manager.level_up.connect(on_level_up)

func update_upgrade_poll(chosen_upgrade: AbilityUpgrade):
	if chosen_upgrade.id == upgrade_giantaxe.id:
		upgrade_pool.add_item(upgrade_giantaxe_damage, 10)

func apply_upgrade(upgrade: ):
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] +=  1
	print("Acquire a new upgrade. Upgrades are now: ", current_upgrades)
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool = upgrade_pool.remove_item(upgrade)
	
	update_upgrade_poll(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)

func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	for i in 2:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades

func on_level_up(current_level: int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate() as UpgradeScreen
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades)
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)

func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
