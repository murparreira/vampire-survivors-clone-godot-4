extends Node2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const BASE_RANGE = 50
var base_rotation = Vector2.RIGHT
var duration: float = 5.0
var player: Player

func _ready():
	animated_sprite_2d.play()
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var tween = create_tween()
	
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	var initial_angle = global_position.angle_to_point(player.global_position)
	var final_angle = initial_angle + 2 * PI
	
	tween.tween_method(rotate_around_player, initial_angle, final_angle, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(queue_free)

func rotate_around_player(angle):
	global_position.x = player.global_position.x + 75 * cos(angle)
	global_position.y = player.global_position.y + 75 * sin(angle)
