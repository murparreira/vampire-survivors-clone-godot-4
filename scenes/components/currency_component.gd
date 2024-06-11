extends Node

class_name CurrencyComponent

@export var currency_scene: PackedScene
@export var health_component: HealthComponent
@export_range(0, 1) var drop_chance: float = 0.3

func _ready():
	health_component.died.connect(on_died)

func on_died():
	var adjusted_drop_chance = drop_chance
	var currency_gain_meta_upgrade_count = MetaProgression.get_meta_upgrade_level("currency_gain")
	if currency_gain_meta_upgrade_count > 0:
		adjusted_drop_chance += .1

	if randf() > adjusted_drop_chance:
		return

	if currency_scene == null:
		return

	if not owner is Node2D:
		return

	var currency_node = currency_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(currency_node)
	currency_node.global_position = owner.global_position + Vector2(10, 10)
