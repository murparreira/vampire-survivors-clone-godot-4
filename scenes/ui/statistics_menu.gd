extends CanvasLayer

@onready var wins_label: Label = %WinsLabel
@onready var loss_label: Label = %LossLabel
@onready var damage_label: Label = %DamageLabel
@onready var kills_label: Label = %KillsLabel
@onready var currency_label: Label = %CurrencyLabel
@onready var back_button: Button = %BackButton
@onready var sister_plays_label: Label = %SisterPlaysLabel
@onready var viking_plays_label: Label = %VikingPlaysLabel
@onready var warrior_plays_label: Label = %WarriorPlaysLabel
@onready var wizard_plays_label: Label = %WizardPlaysLabel

func _ready() -> void:
	back_button.pressed.connect(on_back_button_pressed)
	wins_label.text = str(MetaProgression.save_data["win_total_count"])
	loss_label.text = str(MetaProgression.save_data["loss_total_count"])
	damage_label.text = str(MetaProgression.save_data["total_damage_done"])
	kills_label.text = str(MetaProgression.save_data["total_kills"])
	var currency = 0
	for meta_upgrade in MetaProgression.save_data["meta_upgrades"]:
		var current_upgrade_level = MetaProgression.save_data["meta_upgrades"][meta_upgrade]["level"]
		var current_currency_cost = MetaProgression.save_data["meta_upgrades"][meta_upgrade]["currency_cost"]
		var current_level_multiplier = MetaProgression.save_data["meta_upgrades"][meta_upgrade]["level_multiplier"]
		for level in range(1, current_upgrade_level):
			currency += current_currency_cost * level * current_level_multiplier
	currency += MetaProgression.save_data["meta_upgrade_currency"]
	currency_label.text = str(currency)
	if !MetaProgression.save_data.has("sister_plays"):
		MetaProgression.add_statistics_to_save_data("sister_plays", 0)
	if !MetaProgression.save_data.has("viking_plays"):
		MetaProgression.add_statistics_to_save_data("viking_plays", 0)
	if !MetaProgression.save_data.has("warrior_plays"):
		MetaProgression.add_statistics_to_save_data("warrior_plays", 0)
	if !MetaProgression.save_data.has("wizard_plays"):
		MetaProgression.add_statistics_to_save_data("wizard_plays", 0)
	sister_plays_label.text = str(MetaProgression.save_data["sister_plays"])
	viking_plays_label.text = str(MetaProgression.save_data["viking_plays"])
	warrior_plays_label.text = str(MetaProgression.save_data["warrior_plays"])
	wizard_plays_label.text = str(MetaProgression.save_data["wizard_plays"])

func on_back_button_pressed():
	SceneManager.swap_scenes("res://scenes/ui/main_menu.tscn", get_tree().root, self, "fade_to_black")
