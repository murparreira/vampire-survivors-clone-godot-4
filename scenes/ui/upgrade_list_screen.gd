extends CanvasLayer

@export var upgrade_manager: PackedScene
@onready var longsword = %Longsword
@onready var longsword_quantity = %LongswordQuantity
@onready var longsword_damage = %LongswordDamage
@onready var giantaxe = %Giantaxe
@onready var giantaxe_quantity = %GiantaxeQuantity
@onready var giantaxe_damage = %GiantaxeDamage
@onready var scythe = %Scythe
@onready var scythe_quantity = %ScytheQuantity
@onready var scythe_damage = %ScytheDamage
@onready var anvil = %Anvil
@onready var anvil_quantity = %AnvilQuantity
@onready var anvil_damage = %AnvilDamage
@onready var buff_potion = %BuffPotion
@onready var buff_potion_quantity = %BuffPotionQuantity
@onready var cooldown_potion = %CooldownPotion
@onready var cooldown_potion_quantity = %CooldownPotionQuantity
@onready var quantity_potion = %QuantityPotion
@onready var quantity_potion_quantity = %QuantityPotionQuantity
@onready var speed_potion = %SpeedPotion
@onready var speed_potion_quantity = %SpeedPotionQuantity
@onready var debuff_potion = %DebuffPotion
@onready var debuff_potion_quantity = %DebuffPotionQuantity

func _ready():
	match GameData.character.weapon_upgrade.id:
		"longsword":
			longsword_quantity.text = "x1"
		"giantaxe":
			giantaxe_quantity.text = "x1"
		"scythe":
			scythe_quantity.text = "x1"
		"anvil":
			anvil_quantity.text = "x1"
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	var str_quantity = str(current_upgrades[upgrade.id]["quantity"])
	var additional_damage = (upgrade.base_damage / 2) * (current_upgrades[upgrade.id]["quantity"] - 1)
	match upgrade.id:
		"longsword":
			var longsword_quantity_number = int(longsword_quantity.text.substr(1, 2))
			if longsword_quantity_number == 0:
				longsword_quantity.text = "x1"
			var longsword_damage_number = int(longsword_damage.text.substr(1, 2))
			longsword_damage.text = "+" + str(additional_damage + longsword_damage_number)
		"giantaxe":
			var giantaxe_quantity_number = int(giantaxe_quantity.text.substr(1, 2))
			if giantaxe_quantity_number == 0:
				giantaxe_quantity.text = "x1"
			var giantaxe_damage_number = int(giantaxe_damage.text.substr(1, 2))
			giantaxe_damage.text = "+" + str(additional_damage + giantaxe_damage_number)
		"scythe":
			var scythe_quantity_number = int(scythe_quantity.text.substr(1, 2))
			if scythe_quantity_number == 0:
				scythe_quantity.text = "x1"
			var scythe_damage_number = int(scythe_damage.text.substr(1, 2))
			scythe_damage.text = "+" + str(additional_damage + scythe_damage_number)
		"anvil":
			var anvil_quantity_number = int(anvil_quantity.text.substr(1, 2))
			if anvil_quantity_number == 0:
				anvil_quantity.text = "x1"
			var anvil_damage_number = int(anvil_damage.text.substr(1, 2))
			anvil_damage.text = "+" + str(additional_damage + anvil_damage_number)
		"buff_damage":
			buff_potion_quantity.text = "x" + str_quantity
		"cooldown_reduction":
			cooldown_potion_quantity.text = "x" + str_quantity
		"ability_quantity":
			for new_key in current_upgrades:
				match new_key:
					"longsword":
						var longsword_quantity_number = int(longsword_quantity.text.substr(1, 2)) + 1
						longsword_quantity.text = "x" + str(min(longsword_quantity_number, upgrade.max_quantity))
					"giantaxe":
						var giantaxe_quantity_number = int(giantaxe_quantity.text.substr(1, 2)) + 1
						giantaxe_quantity.text = "x" + str(min(giantaxe_quantity_number, upgrade.max_quantity))
					"scythe":
						var scythe_quantity_number = int(scythe_quantity.text.substr(1, 2)) + 1
						scythe_quantity.text = "x" + str(min(scythe_quantity_number, upgrade.max_quantity))
					"anvil":
						var anvil_quantity_number = int(anvil_quantity.text.substr(1, 2)) + 1
						anvil_quantity.text = "x" + str(min(anvil_quantity_number, upgrade.max_quantity))
					_:
						continue
			quantity_potion_quantity.text = "x" + str_quantity
		"player_speed":
			speed_potion_quantity.text = "x" + str_quantity
		"debuff_enemies":
			debuff_potion_quantity.text = "x" + str_quantity
		_:
			pass
