extends CharacterBody2D

@onready var visuals = $Visuals
@onready var sprite = $Visuals/Sprite2D
@onready var velocity_component = $VelocityComponent
@onready var damage_component = $DamageComponent
@onready var health_component = $HealthComponent
@onready var hurtbox_collision_shape = $HurtboxComponent/CollisionShape2D
@onready var collision_shape = $CollisionShape2D

const TYPE = 'spider'

var boss = false
var is_moving = false

func _ready():
	$HurtboxComponent.hit.connect(on_hit)

func _process(delta):
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)

func set_is_moving(moving: bool):
	is_moving = moving

func on_hit():
	$RandomStreamPlayer2DComponent.play_random()
