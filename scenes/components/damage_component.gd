extends Node

class_name DamageComponent

@export var damage: int = 3
var current_damage

func increase_damage(damage_amount_to_increase: int):
	damage += damage_amount_to_increase

func decrease_damage(damage_amount_to_decrease: int):
	damage -= damage_amount_to_decrease
