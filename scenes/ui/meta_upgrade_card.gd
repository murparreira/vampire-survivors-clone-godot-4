extends PanelContainer

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var purchase_button = %PurchaseButton
@onready var currency_label = %CurrencyLabel
@onready var level_label = %LevelLabel
@onready var max_label: Label = %MaxLabel

var meta_upgrade: MetaUpgrade

func _ready():
	purchase_button.pressed.connect(on_purchase_button_pressed)

func set_meta_upgrade_data(meta_upgrade: MetaUpgrade):
	self.meta_upgrade = meta_upgrade
	name_label.text = meta_upgrade.name
	description_label.text = meta_upgrade.description
	update_button()
	
func update_button():
	if !MetaProgression.save_data["meta_upgrades"].has(meta_upgrade.id):
		MetaProgression.save_data["meta_upgrades"][meta_upgrade.id] = MetaProgression.initial_save_data["meta_upgrades"][meta_upgrade.id]
	var current_level = MetaProgression.save_data["meta_upgrades"][meta_upgrade.id]["level"]
	var level_multiplier = MetaProgression.save_data["meta_upgrades"][meta_upgrade.id]["level_multiplier"]
	var meta_upgrade_currency = MetaProgression.save_data["meta_upgrade_currency"]
	var is_maxed = current_level >= meta_upgrade.max_quantity
	var adjusted_cost = meta_upgrade.currency_cost
	if current_level >= 1:
		adjusted_cost = meta_upgrade.currency_cost * current_level * level_multiplier
	if is_maxed:
		purchase_button.text = "Upgraded to Max"
		currency_label.text = "Max"
	else:
		currency_label.text = str(meta_upgrade_currency) + "/" + str(adjusted_cost)
	level_label.text = "x%d" % current_level
	if is_maxed:
		max_label.visible = true
		purchase_button.visible = false
	else:
		max_label.visible = false
		purchase_button.visible = true
		purchase_button.disabled = meta_upgrade_currency <= adjusted_cost

func on_purchase_button_pressed():
	if meta_upgrade == null:
		return
	var meta_upgrade_currency = MetaProgression.save_data["meta_upgrade_currency"]
	var current_level = MetaProgression.save_data["meta_upgrades"][meta_upgrade.id]["level"]
	var level_multiplier = MetaProgression.save_data["meta_upgrades"][meta_upgrade.id]["level_multiplier"]
	MetaProgression.update_meta_upgrade(meta_upgrade.id, "level", current_level + 1)
	var adjusted_meta_upgrade_currency = meta_upgrade.currency_cost
	if current_level >= 1:
		adjusted_meta_upgrade_currency = meta_upgrade.currency_cost * current_level * level_multiplier
	MetaProgression.save_data["meta_upgrade_currency"] -= max(0, adjusted_meta_upgrade_currency)
	MetaProgression.save()
	get_tree().call_group("meta_upgrade_card", "update_button")
