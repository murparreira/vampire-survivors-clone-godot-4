extends PanelContainer

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var purchase_button = %PurchaseButton
@onready var currency_label = %CurrencyLabel
@onready var level_label = %LevelLabel

var meta_upgrade: MetaUpgrade

func _ready():
	purchase_button.pressed.connect(on_purchase_button_pressed)

func set_meta_upgrade_data(meta_upgrade: MetaUpgrade):
	self.meta_upgrade = meta_upgrade
	name_label.text = meta_upgrade.name
	description_label.text = meta_upgrade.description
	update_button()

func select_card():
	$AnimationPlayer.play("selected")
	
func update_button():
	var current_level = MetaProgression.save_data["meta_upgrades"][meta_upgrade.id]["level"]
	var level_multiplier = MetaProgression.save_data["meta_upgrades"][meta_upgrade.id]["level_multiplier"]
	var meta_upgrade_currency = MetaProgression.save_data["meta_upgrade_currency"]
	var is_maxed = current_level >= meta_upgrade.max_quantity
	var adjusted_cost = meta_upgrade.currency_cost
	if current_level >= 1:
		adjusted_cost = meta_upgrade.currency_cost * current_level * level_multiplier
	purchase_button.disabled = is_maxed || meta_upgrade_currency <= adjusted_cost
	if is_maxed:
		purchase_button.text = "Upgraded to Max"
	currency_label.text = str(meta_upgrade_currency) + "/" + str(adjusted_cost)
	level_label.text = "x%d" % current_level

func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		select_card()

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
	$AnimationPlayer.play("selected")
