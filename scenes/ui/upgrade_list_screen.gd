extends CanvasLayer

@export var upgrade_manager: PackedScene
@onready var longsword = %Longsword
@onready var longsword_quantity = %LongswordQuantity
@onready var giantaxe = %Giantaxe
@onready var giantaxe_quantity = %GiantaxeQuantity
@onready var scythe = %Scythe
@onready var scythe_quantity = %ScytheQuantity
@onready var buff_potion = %BuffPotion
@onready var buff_potion_quantity = %BuffPotionQuantity
@onready var cooldown_potion = %CooldownPotion
@onready var cooldown_potion_quantity = %CooldownPotionQuantity
@onready var quantity_potion = %QuantityPotion
@onready var quantity_potion_quantity = %QuantityPotionQuantity
@onready var speed_potion = %SpeedPotion
@onready var speed_potion_quantity = %SpeedPotionQuantity

func _ready():
	longsword_quantity.text = "x0"
	giantaxe_quantity.text = "x0"
	scythe_quantity.text = "x0"
	buff_potion_quantity.text = "x0"
	cooldown_potion_quantity.text = "x0"
	quantity_potion_quantity.text = "x0"
	speed_potion_quantity.text = "x0"
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	for key in current_upgrades:
		var value = current_upgrades[key]
		var str_quantity = str(value["quantity"])
		match key:
			"longsword":
				longsword_quantity.text = "x" + str_quantity
			"giantaxe":
				giantaxe_quantity.text = "x" + str_quantity
			"scythe":
				scythe_quantity.text = "x" + str_quantity
			"buff_damage":
				buff_potion_quantity.text = "x" + str_quantity
			"cooldown_reduction":
				cooldown_potion_quantity.text = "x" + str_quantity
			"ability_quantity":
				quantity_potion_quantity.text = "x" + str_quantity
			"player_speed":
				speed_potion_quantity.text = "x" + str_quantity
			_:
				continue
