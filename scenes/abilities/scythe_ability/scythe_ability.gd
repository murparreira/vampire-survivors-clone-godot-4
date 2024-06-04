extends CharacterBody2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var velocity_component = $VelocityComponent
@onready var timer = $Timer

var random_direction = Vector2.RIGHT

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	
func _process(delta):
	velocity_component.accelerate_in_direction(random_direction)
	velocity_component.move(self)

func on_timer_timeout():
	queue_free()
