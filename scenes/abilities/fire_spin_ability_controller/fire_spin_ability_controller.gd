extends Node

@export var fire_spin_ability_scene: PackedScene

const BASE_RADIUS = 75

var base_damage = 2
var additional_damage_from_upgrades = 0
var additional_damage_percent = 1
var base_wait_time
var fire_spin_number = 1

func _ready():
	var attack_gain_level = MetaProgression.save_data["meta_upgrades"]["attack_gain"]["level"]
	if attack_gain_level >= 1:
		base_damage *= 1 + (attack_gain_level * .2)
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
	
	var fire_spins = min(fire_spin_number, 5) + 3
	var angle_step = 360.0 / fire_spins

	for i in range(fire_spins):
		var angle = deg_to_rad(i * angle_step)
		var spawn_position = Vector2(player.global_position.x + BASE_RADIUS * cos(angle), player.global_position.y + BASE_RADIUS * sin(angle))
		var fire_spin_instance = fire_spin_ability_scene.instantiate() as Node2D
		if fire_spin_instance == null:
			return
		fire_spin_instance.global_position = spawn_position
		foreground_layer.add_child(fire_spin_instance)
		fire_spin_instance.hitbox_component.damage = (base_damage + additional_damage_from_upgrades) * additional_damage_percent

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "fire_spin":
		if current_upgrades["fire_spin"]["quantity"] == 2:
			additional_damage_from_upgrades += 1
			pass
		elif current_upgrades["fire_spin"]["quantity"] == 3:
			additional_damage_from_upgrades += 2
			pass
		elif current_upgrades["fire_spin"]["quantity"] == 4:
			additional_damage_from_upgrades += 4
			pass
		elif current_upgrades["fire_spin"]["quantity"] == 5:
			additional_damage_from_upgrades += 8
			pass
		print("Fire Spin level upgraded. Now: ", current_upgrades["fire_spin"]["quantity"])
	elif upgrade.id == "cooldown_reduction":
		var percent_reduction = current_upgrades["cooldown_reduction"]["quantity"] * 0.1
		$Timer.wait_time = base_wait_time * (1 - percent_reduction)
		$Timer.start()
		print("Fire Spin wait time decreased. Now: ", $Timer.wait_time)
	elif upgrade.id == "buff_damage":
		additional_damage_percent = 1 + (current_upgrades["buff_damage"]["quantity"] * .1)
		print("Fire Spin damage increased. Now: ", base_damage * additional_damage_percent)
	elif upgrade.id == "ability_quantity":
		fire_spin_number += 1
		print("Number of Fire Spins increased. Now: ", fire_spin_number)
	else:
		return
