extends Node

@export var scythe_ability: PackedScene

var base_damage = 6
var additional_damage_from_upgrades = 0
var additional_damage_percent = 1
var base_wait_time
var scythe_number = 1

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
	
	for i in scythe_number:
		var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
		for j in 4:
			var scythe_instance = scythe_ability.instantiate() as Node2D
			if scythe_instance == null:
				return
			foreground_layer.add_child(scythe_instance)
			
			scythe_instance.random_direction = random_direction
			scythe_instance.global_position = player.global_position + (random_direction * 10)
			scythe_instance.rotation = atan2(random_direction.y, random_direction.x) + 90
			scythe_instance.hitbox_component.damage = (base_damage + additional_damage_from_upgrades) * additional_damage_percent
			
			random_direction = random_direction.rotated(deg_to_rad(90))

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "scythe":
		if current_upgrades["scythe"]["quantity"] == 2:
			additional_damage_from_upgrades += 3
			pass
		elif current_upgrades["scythe"]["quantity"] == 3:
			additional_damage_from_upgrades += 6
			pass
		elif current_upgrades["scythe"]["quantity"] == 4:
			additional_damage_from_upgrades += 9
			pass
		elif current_upgrades["scythe"]["quantity"] == 5:
			additional_damage_from_upgrades += 12
			pass
		print("Scythe level upgraded. Now: ", current_upgrades["scythe"]["quantity"])
	elif upgrade.id == "cooldown_reduction":
		var percent_reduction = current_upgrades["cooldown_reduction"]["quantity"] * 0.1
		$Timer.wait_time = base_wait_time * (1 - percent_reduction)
		$Timer.start()
		print("Scythe wait time decreased. Now: ", $Timer.wait_time)
	elif upgrade.id == "buff_damage":
		additional_damage_percent = 1 + (current_upgrades["buff_damage"]["quantity"] * .1)
		print("Scythe damage increased. Now: ", base_damage * additional_damage_percent)
	elif upgrade.id == "ability_quantity":
		scythe_number += 1
		print("Number of Scythes increased. Now: ", scythe_number)
	else:
		return
