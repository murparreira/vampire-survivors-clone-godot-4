extends Node

const MAX_RANGE = 150

@export var longsword_ability: PackedScene

var base_damage = 5
var additional_damage_percent = 1
var base_wait_time
var longsword_number = 1
var number_of_enemies_to_hit

func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy : Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)

	if longsword_number > enemies.size():
		number_of_enemies_to_hit = enemies.size()
	else :
		number_of_enemies_to_hit = longsword_number

	for i in number_of_enemies_to_hit:
		var longsword_instance = longsword_ability.instantiate() as Node2D
		var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
		foreground_layer.add_child(longsword_instance)
		longsword_instance.hitbox_component.damage = base_damage * additional_damage_percent
		longsword_instance.global_position = enemies[i].global_position
		longsword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4

		var enemy_direction = enemies[i].global_position - longsword_instance.global_position
		longsword_instance.rotation = enemy_direction.angle()

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "cooldown_reduction":
		var percent_reduction = current_upgrades["cooldown_reduction"]["quantity"] * 0.1
		$Timer.wait_time = base_wait_time * (1 - percent_reduction)
		$Timer.start()
		print("Longsword wait time decreased. Now: ", $Timer.wait_time)
	elif upgrade.id == "buff_damage":
		additional_damage_percent = 1 + (current_upgrades["buff_damage"]["quantity"] * .1)
		print("Longsword damage increased. Now: ", base_damage * additional_damage_percent)
	elif upgrade.id == "ability_quantity":
		longsword_number += 1
		print("Number of Longswords increased. Now: ", longsword_number)
