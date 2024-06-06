extends Node

@export var anvil_ability_scene: PackedScene

const BASE_RANGE = 100

var base_damage = 12
var additional_damage_from_upgrades = 0
var additional_damage_percent = 1
var base_wait_time
var anvil_number = 1

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
	
	for i in min(anvil_number, 5):
		var anvil_instance = anvil_ability_scene.instantiate()
		if anvil_instance == null:
			return
		foreground_layer.add_child(anvil_instance)
		var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
		var spawn_position = player.global_position + (direction * randf_range(0, BASE_RANGE))
		anvil_instance.global_position = spawn_position
		anvil_instance.hitbox_component.damage = (base_damage + additional_damage_from_upgrades) * additional_damage_percent

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "anvil":
		if current_upgrades["anvil"]["quantity"] == 2:
			additional_damage_from_upgrades += 6
			pass
		elif current_upgrades["anvil"]["quantity"] == 3:
			additional_damage_from_upgrades += 12
			pass
		elif current_upgrades["anvil"]["quantity"] == 4:
			additional_damage_from_upgrades += 18
			pass
		elif current_upgrades["anvil"]["quantity"] == 5:
			additional_damage_from_upgrades += 24
			pass
		print("Anvil level upgraded. Now: ", current_upgrades["anvil"]["quantity"])
	elif upgrade.id == "cooldown_reduction":
		var percent_reduction = current_upgrades["cooldown_reduction"]["quantity"] * 0.1
		$Timer.wait_time = base_wait_time * (1 - percent_reduction)
		$Timer.start()
		print("Anvil wait time decreased. Now: ", $Timer.wait_time)
	elif upgrade.id == "buff_damage":
		additional_damage_percent = 1 + (current_upgrades["buff_damage"]["quantity"] * .1)
		print("Anvil damage increased. Now: ", base_damage * additional_damage_percent)
	elif upgrade.id == "ability_quantity":
		anvil_number += 1
		print("Number of Anvils increased. Now: ", anvil_number)
	else:
		return
