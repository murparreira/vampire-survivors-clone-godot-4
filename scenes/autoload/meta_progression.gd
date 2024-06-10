extends Node

const SAVE_FILE_PATH = "user://game.save"

var save_data: Dictionary = {
	"win_total_count": 0,
	"loss_total_count": 0,
	"meta_upgrade_currency": 0,
	"meta_upgrades": {}
}

func _ready():
	load_save_file()
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)

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
			"quantity": 0
		}
	save_data["meta_upgrades"][meta_upgrade.id]["quantity"] += 1
	print("Altered save data: ", save_data)

func get_meta_upgrade_count(meta_upgrade_id: String):
	if save_data["meta_upgrades"].has(meta_upgrade_id):
		return save_data["meta_upgrades"][meta_upgrade_id]["quantity"]
	return 0

func add_statistics_to_save_data(statistic: String, count: int):
	if save_data.has(statistic):
		save_data[statistic] += count
	else:
		save_data[statistic] = 0

func on_experience_vial_collected(number: float):
	save_data["meta_upgrade_currency"] += number
