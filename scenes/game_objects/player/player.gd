extends CharacterBody2D

class_name Player

@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_regen_timer: Timer = $HealthRegenTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var sprite = $%Sprite2D
@onready var velocity_component = $VelocityComponent

var number_colliding_bodies = 0
var base_speed = 0

func _ready():
	base_speed = velocity_component.max_speed
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	if MetaProgression.save_data["meta_upgrades"].has("health_regen"):
		if MetaProgression.save_data["meta_upgrades"]["health_regen"]["level"] == 1:
			health_regen_timer.timeout.connect(on_health_regen_timer_timeout)
			health_regen_timer.start()
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()

func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
		
	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)

func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)

func check_deal_damage(damage_amount: float):
	if GameData.god_mode:
		return
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	health_component.damage(damage_amount)
	damage_interval_timer.start()
	print("Took a hit, enemy inflicted " + str(damage_amount) + " damage")
	print("Took a hit, HP is now: ", health_component.current_health)

func update_health_display():
	health_bar.value = health_component.get_health_percentage()

func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage(other_body.damage_component.damage)
	
func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1

func on_damage_interval_timer_timeout():
	#check_deal_damage()
	pass
	
func on_health_regen_timer_timeout():
	health_component.damage(-2)

func on_health_changed(damage_amount: float):
	update_health_display()
	GameEvents.emit_player_damaged(damage_amount)
	if damage_amount > 0:
		$RandomStreamPlayer2DComponent.play_random()
	
func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		if current_upgrades[ability_upgrade.id]["quantity"] == 1:
			abilities.add_child(ability_upgrade.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * .3)
		print("Got a speed upgrade, now your speed is ", velocity_component.max_speed)
	elif ability_upgrade.id == "restore_life":
		var health_to_restore = health_component.max_health/2 + health_component.current_health
		if health_to_restore < health_component.max_health:
			health_component.current_health = health_to_restore
		else:
			health_component.current_health = health_component.max_health
		update_health_display()
