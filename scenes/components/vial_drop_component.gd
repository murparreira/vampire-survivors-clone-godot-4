extends Node

class_name VialDropComponent

@export var experience_vial_scene: PackedScene
@export var health_component: HealthComponent
@export_range(0, 1) var drop_chance: float = 0.5

func _ready():
	health_component.died.connect(on_died)

func on_died():
	if randf() > drop_chance:
		return

	if experience_vial_scene == null:
		return
		
	if not owner is Node2D:
		return

	var experimental_vial_node = experience_vial_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(experimental_vial_node)
	experimental_vial_node.global_position = owner.global_position
