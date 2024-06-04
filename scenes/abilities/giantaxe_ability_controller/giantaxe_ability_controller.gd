extends Node

@export var giantaxe_ability: PackedScene

var base_damage = 8
var additional_damage_from_upgrades = 0
var additional_damage_percent = 1
var base_wait_time
var giantaxe_number = 1

func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	if foreground_layer == null:
		return
	
	for i in giantaxe_number:
		var giantaxe_instance = giantaxe_ability.instantiate() as Node2D
		if giantaxe_instance == null:
			return
		foreground_layer.add_child(giantaxe_instance)
		giantaxe_instance.global_position = player.global_position
		giantaxe_instance.hitbox_component.damage = (base_damage + additional_damage_from_upgrades) * additional_damage_percent

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "giantaxe":
		if current_upgrades["giantaxe"]["quantity"] == 2:
			additional_damage_from_upgrades += 4
			pass
		elif current_upgrades["giantaxe"]["quantity"] == 3:
			additional_damage_from_upgrades += 8
			pass
		elif current_upgrades["giantaxe"]["quantity"] == 4:
			additional_damage_from_upgrades += 12
			pass
		elif current_upgrades["giantaxe"]["quantity"] == 5:
			additional_damage_from_upgrades += 16
			pass
		print("Giantaxe level upgraded. Now: ", current_upgrades["giantaxe"]["quantity"])
	elif upgrade.id == "cooldown_reduction":
		var percent_reduction = current_upgrades["cooldown_reduction"]["quantity"] * 0.1
		$Timer.wait_time = base_wait_time * (1 - percent_reduction)
		$Timer.start()
		print("Giantaxe wait time decreased. Now: ", $Timer.wait_time)
	elif upgrade.id == "buff_damage":
		additional_damage_percent = 1 + (current_upgrades["buff_damage"]["quantity"] * .1)
		print("Giantaxe damage increased. Now: ", base_damage * additional_damage_percent)
	elif upgrade.id == "ability_quantity":
		giantaxe_number += 1
		print("Number of Giantaxes increased. Now: ", giantaxe_number)
	else:
		return
