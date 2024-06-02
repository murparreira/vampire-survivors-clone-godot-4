extends Node

@export var giantaxe_ability: PackedScene

var damage = 10

func _ready():
	$Timer.timeout.connect(on_timer_timeout)

func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	if foreground_layer == null:
		return
		
	var giantaxe_instance = giantaxe_ability.instantiate() as Node2D
	if giantaxe_instance == null:
		return

	foreground_layer.add_child(giantaxe_instance)
	giantaxe_instance.global_position = player.global_position
	giantaxe_instance.hitbox_component.damage = damage