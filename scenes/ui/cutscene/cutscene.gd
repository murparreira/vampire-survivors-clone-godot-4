extends Node2D

@onready var sprite = $%Sprite2D
@onready var path_follow_2d = $Path2D/PathFollow2D
@onready var first_label = $%FirstLabel
@onready var second_label = %SecondLabel
@onready var third_label = %ThirdLabel
@onready var animation_player = $Path2D/PathFollow2D/Camera2D/Sprite2D/AnimationPlayer
@onready var timer_first_label = $%TimerFirstLabel
@onready var timer_second_label = $%TimerSecondLabel
@onready var timer_third_label = $%TimerThirdLabel

var speed = 0.15
var stop_following = true

func _ready():
	sprite.texture = GameData.character.character_sprite
	first_label.visible = false
	second_label.visible = false
	third_label.visible = false
	timer_first_label.timeout.connect(on_first_timer_timeout.bind(first_label))
	timer_second_label.timeout.connect(on_second_timer_timeout.bind(second_label))
	timer_third_label.timeout.connect(on_third_timer_timeout.bind(third_label))
	animation_player.play("walk")

func _process(delta):
	if stop_following:
		return
	path_follow_2d.progress_ratio += speed * delta

func cutscene_ended():
	SceneManager.swap_scenes("res://scenes/main/main.tscn", get_tree().root, self, "fade_to_black")

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		cutscene_ended()

func on_first_timer_timeout(first_label):
	first_label.visible = true
	var tween = create_tween()
	tween.tween_property(first_label, "visible_ratio", 1.0, 3.0).from(0.0)
	await tween.finished
	await get_tree().create_timer(1.0).timeout
	stop_following = false
	first_label.visible = false
	timer_second_label.start()
	
func on_second_timer_timeout(second_label):
	stop_following = true
	second_label.visible = true
	var tween = create_tween()
	tween.tween_property(second_label, "visible_ratio", 1.0, 3.0).from(0.0)
	await tween.finished
	await get_tree().create_timer(1.0).timeout
	stop_following = false
	second_label.visible = false
	timer_third_label.start()
	
func on_third_timer_timeout(third_label):
	stop_following = true
	third_label.visible = true
	var tween = create_tween()
	tween.tween_property(third_label, "visible_ratio", 1.0, 1.0).from(0.0)
	await tween.finished
	await get_tree().create_timer(1.0).timeout
	stop_following = false
	third_label.visible = false
	cutscene_ended()
