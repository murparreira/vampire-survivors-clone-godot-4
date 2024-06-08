extends Node

signal boss_defeated

@export var end_screen_scene: PackedScene
@export var basic_enemy_scene: PackedScene
@export var spider_enemy_scene: PackedScene
@export var bat_enemy_scene: PackedScene
@export var crab_enemy_scene: PackedScene
@export var mimic_enemy_scene: PackedScene

@export var upgrade_manager: UpgradeManager
@export var arena_time_manager: Node

@onready var timer = $Timer

const SPAWN_RADIUS = 330

var base_spawn_time = 0
var number_spawned_enemies = 1
var enemy_table = WeightedTable.new()

func _ready():
	enemy_table.add_item(basic_enemy_scene, 20)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	arena_time_manager.boss_enemy_spawn.connect(on_boss_enemy_spawn)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 8:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var additional_check_offset = random_direction * 20
		
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_check_offset, 1 << 0)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(45))
		
		# Draw raycast as line if Debug -> Visible Collision Shapes is enabled
		if get_tree().debug_collisions_hint:
			var debug_line = Line2D.new()
			debug_line.z_index = 99 # Draw on top of everything
			debug_line.width = 1
			debug_line.add_point(query_parameters.from, 0)
			debug_line.add_point(query_parameters.to, 1)
			add_child(debug_line)
			if !result.is_empty():
				debug_line.set_point_position(1, result.get("position"))
				debug_line.default_color = Color.RED

	return spawn_position

func despawn_all_enemies():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.queue_free()

func spawn_enemy(enemy: Node2D):	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()
	if upgrade_manager.current_upgrades.has("debuff_enemies"):
		enemy.damage_component.decrease_damage_by_percentage(upgrade_manager.current_upgrades["debuff_enemies"]["quantity"] * .1)
		GameEvents.enemy_spawned.emit(1)

func set_boss_attributes(boss_enemy: Node2D):
	boss_enemy.sprite.scale = Vector2(5, 5)
	boss_enemy.velocity_component.max_speed = 300
	boss_enemy.velocity_component.acceleration = 1
	boss_enemy.damage_component.damage = 30
	boss_enemy.health_component.max_health = 3000
	boss_enemy.health_component.current_health = 3000
	if boss_enemy.collision_shape.shape is RectangleShape2D:
		boss_enemy.collision_shape.shape.size = Vector2(30, 30)
	else:
		boss_enemy.collision_shape.shape.radius = 30
	boss_enemy.collision_shape.position.y = -30
	if boss_enemy.collision_shape.shape is RectangleShape2D:
		boss_enemy.hurtbox_collision_shape.shape.size = Vector2(42, 42)
	else:
		boss_enemy.hurtbox_collision_shape.shape.radius = 42
	boss_enemy.hurtbox_collision_shape.position.y = -30
	boss_enemy.boss = true
	boss_enemy.health_component.died.connect(on_boss_defeat)

func on_timer_timeout():
	timer.start()
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	for i in number_spawned_enemies:
		var enemy_scene = enemy_table.pick_item()
		var enemy = enemy_scene.instantiate() as Node2D
		spawn_enemy(enemy)

func on_arena_difficulty_increased(arena_difficulty: int):
	if $Timer == null:
		return
	var time_off = (0.1 / 12) * arena_difficulty
	time_off = max(time_off, 0.7)
	timer.wait_time = base_spawn_time - time_off
	if arena_difficulty == 6:
		enemy_table.add_item(spider_enemy_scene, 12)
		number_spawned_enemies += 1
	elif arena_difficulty == 12:
		enemy_table.add_item(bat_enemy_scene, 6)
		enemy_table.add_item(crab_enemy_scene, 1)
		number_spawned_enemies += 1
	elif arena_difficulty == 18:
		enemy_table.add_item(spider_enemy_scene, 16)
		enemy_table.add_item(bat_enemy_scene, 10)
		enemy_table.add_item(crab_enemy_scene, 2)
		number_spawned_enemies += 1
	elif arena_difficulty == 24:
		enemy_table.add_item(crab_enemy_scene, 4)
		number_spawned_enemies += 1
	elif arena_difficulty == 30:
		number_spawned_enemies += 1
	elif arena_difficulty == 36:
		number_spawned_enemies += 2
	elif arena_difficulty == 42:
		enemy_table.add_item(mimic_enemy_scene, 10)
		number_spawned_enemies += 3
	print("Arena difficulty increased, level: " + str(arena_difficulty) + ". Spawning " + str(number_spawned_enemies) + " enemies per " + str(timer.wait_time) + " seconds")

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "debuff_enemies":
		var enemies = get_tree().get_nodes_in_group("enemy")
		for enemy in enemies:
			enemy.damage_component.decrease_damage(1)
			
func on_boss_enemy_spawn():
	$Timer.queue_free()
	despawn_all_enemies()
	var boss_enemy_scene = enemy_table.pick_item()
	var boss_enemy = boss_enemy_scene.instantiate() as Node2D
	spawn_enemy(boss_enemy)
	set_boss_attributes(boss_enemy)

func on_boss_defeat():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.play_jingle()
