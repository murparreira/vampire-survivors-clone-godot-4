extends Node2D

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite = $Sprite2D

func _ready():
	$Area2D.area_entered.connect(on_area_entered)
	$Timer.timeout.connect(on_timer_timeout)
	$AnimationPlayer.play("spin")

func collect():
	GameEvents.currency_collected.emit(randi_range(1, 2))
	queue_free()

func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	global_position = start_position.lerp(player.global_position, percent)
	
func disable_collision():
	collision_shape_2d.disabled = true

func on_area_entered(other_area: Area2D):
	Callable(disable_collision).call_deferred()
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, .5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ZERO, .05).set_delay(.45)
	tween.chain()
	tween.tween_callback(collect)
	$RandomStreamPlayer2DComponent.play_random()
	
func on_timer_timeout():
	queue_free()
