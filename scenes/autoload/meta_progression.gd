extends Node

const SAVE_FILE_PATH = "user://game.save"

var save_data: Dictionary = {
	"win_total_count": 0,
	"loss_total_count": 0,
	"meta_upgrade_currency": 0,
	"meta_upgrades": {
		"experience_gain": {
			"level": 0,
			"currency_cost": 100,
			"level_multiplier": 2,
		},
		"currency_gain": {
			"level": 0,
			"currency_cost": 200,
			"level_multiplier": 2,
		},
		"attack_gain": {
			"level": 0,
			"currency_cost": 1000,
			"level_multiplier": 2,
		},
		"health_regen": {
			"level": 0,
			"currency_cost": 500,
			"level_multiplier": 2,
		}
	}
}

var initial_save_data = {}

func _ready():
	initial_save_data = save_data
	load_save_file()
	print(save_data)
	GameEvents.currency_collected.connect(on_currency_collected)

func load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		return
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()
	
func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)

func add_meta_upgrade(meta_upgrade: MetaUpgrade):
	if !save_data["meta_upgrades"].has(meta_upgrade.id):
		save_data["meta_upgrades"][meta_upgrade.id] = {
			"level": 0,
			"currency_cost": 0,
			"level_multiplier": 0,
			"current_currency_spent": 0
		}
	save_data["meta_upgrades"][meta_upgrade.id]["level"] += 1
	print("Altered save data: ", save_data)
	
func update_meta_upgrade(meta_upgrade_id: String, attribute: String, quantity: int):
	save_data["meta_upgrades"][meta_upgrade_id][attribute] = quantity

func get_meta_upgrade_level(meta_upgrade_id: String):
	if save_data["meta_upgrades"].has(meta_upgrade_id):
		return save_data["meta_upgrades"][meta_upgrade_id]["level"]
	return 0

func add_statistics_to_save_data(statistic: String, count: int):
	if save_data.has(statistic):
		save_data[statistic] += count
	else:
		save_data[statistic] = 0

func on_currency_collected(number: int):
	save_data["meta_upgrade_currency"] += number
