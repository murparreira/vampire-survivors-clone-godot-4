extends Node

signal experience_vial_collected(number: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged()
signal enemy_defeated(number: int)
signal enemy_spawned(number: int)
signal enemy_despawned(number: int)

func emit_experience_vial_collected(number: float):
	experience_vial_collected.emit(number)
	
func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)

func emit_player_damaged():
	player_damaged.emit()

func emit_enemy_defeated(number: int):
	enemy_defeated.emit(number)

func emit_enemy_spawned(number: int):
	enemy_spawned.emit(number)
	
func emit_enemy_despawned(number: int):
	enemy_despawned.emit(number)
