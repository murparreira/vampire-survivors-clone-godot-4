extends Node

class_name DamageComponent

@export var damage: float = 3.0
var current_damage

func increase_damage(damage_amount_to_increase: float):
	damage += damage_amount_to_increase

func increase_damage_by_percentage(damage_percentage_to_increase: float):
	damage = damage + (damage * damage_percentage_to_increase)

func decrease_damage(damage_amount_to_decrease: float):
	damage -= damage_amount_to_decrease
	damage = max(damage, 1.0)

func decrease_damage_by_percentage(damage_percentage_to_decrease: float):
	damage = damage - (damage * damage_percentage_to_decrease)
	damage = max(damage, 1.0)
