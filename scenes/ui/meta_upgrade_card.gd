extends PanelContainer

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var progress_bar = $%ProgressBar
@onready var purchase_button = %PurchaseButton
@onready var progress_label = %ProgressLabel
@onready var count_label = %CountLabel

var meta_upgrade: MetaUpgrade

func _ready():
	purchase_button.pressed.connect(on_purchase_button_pressed)

func set_meta_upgrade_data(meta_upgrade: MetaUpgrade):
	self.meta_upgrade = meta_upgrade
	name_label.text = meta_upgrade.name
	description_label.text = meta_upgrade.description
	update_progress()

func select_card():
	$AnimationPlayer.play("selected")
	
func update_progress():
	var current_quantity = 0
	if MetaProgression.save_data["meta_upgrades"].has(meta_upgrade.id):
		current_quantity = MetaProgression.save_data["meta_upgrades"][meta_upgrade.id]["quantity"]
	var is_maxed = current_quantity >= meta_upgrade.max_quantity
	var currency = MetaProgression.save_data["meta_upgrade_currency"]
	var percent = currency / meta_upgrade.currency_cost
	percent = min(percent, 1)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1 || is_maxed
	purchase_button.disabled = false
	if is_maxed:
		purchase_button.text = "Max"
	progress_label.text = str(currency) + "/" + str(meta_upgrade.currency_cost)
	count_label.text = "x%d" % current_quantity

func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		select_card()

func on_purchase_button_pressed():
	if meta_upgrade == null:
		return
	MetaProgression.add_meta_upgrade(meta_upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= meta_upgrade.currency_cost
	MetaProgression.save()
	get_tree().call_group("meta_upgrade_card", "update_progress")
	$AnimationPlayer.play("selected")
