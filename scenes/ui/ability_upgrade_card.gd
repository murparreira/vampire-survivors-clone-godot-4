extends PanelContainer

signal selected

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var sprite: Sprite2D = $%Sprite2D

func _ready():
	gui_input.connect(on_gui_input)

func set_ability_upgrade_data(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description
	sprite.texture = upgrade.sprite

func on_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click"):
		selected.emit()
