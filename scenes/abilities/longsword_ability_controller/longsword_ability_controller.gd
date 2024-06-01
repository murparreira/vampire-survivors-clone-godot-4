extends Node

const MAX_RANGE = 150

@export var longsword_ability: PackedScene

var damage = 5
var base_wait_time

func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	var enemies = get_tree().get_nodes_in_group("basic_enemy")
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
	var longsword_instance = longsword_ability.instantiate() as Node2D
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(longsword_instance)
	longsword_instance.hitbox_component.damage = damage
	longsword_instance.global_position = enemies[0].global_position
	longsword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4

	var enemy_direction = enemies[0].global_position - longsword_instance.global_position
	longsword_instance.rotation = enemy_direction.angle()

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id != "longsword_quickness":
		return
	var percent_reduction = current_upgrades["longsword_quickness"]["quantity"] * 0.2
	$Timer.wait_time = base_wait_time * (1 - percent_reduction)
	$Timer.start()
	print("Longsword wait time decreased. Now: ", $Timer.wait_time)
