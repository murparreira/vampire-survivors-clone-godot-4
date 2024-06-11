extends CanvasLayer

@export var meta_upgrades: Array[MetaUpgrade] = []
@onready var grid_container = %GridContainer
@onready var back_button = %BackButton
@onready var total_currency_label = %TotalCurrencyLabel

var meta_upgrade_card_scene = preload("res://scenes/ui/meta_upgrade_card.tscn")

func _ready():
	back_button.pressed.connect(on_back_button_pressed)
	for meta_upgrade in meta_upgrades:
		var meta_upgrade_card_instance = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_meta_upgrade_data(meta_upgrade)

func on_back_button_pressed():
	SceneManager.swap_scenes("res://scenes/ui/character_selection_screen.tscn", get_tree().root, self, "fade_to_black")
