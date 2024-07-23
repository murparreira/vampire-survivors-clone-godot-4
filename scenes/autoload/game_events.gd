extends Node

signal character_selected(character: Character)
signal experience_vial_collected(number: float)
signal currency_collected(number: int)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged(damage_amount: float)
signal enemy_defeated(number: int)
signal enemy_spawned(number: int)
signal enemy_despawned(number: int)
signal boss_spawned

func emit_character_selected(character: Character):
	character_selected.emit(character)

func emit_experience_vial_collected(number: float):
	experience_vial_collected.emit(number)
	
func emit_currency_collected(number: int):
	currency_collected.emit(number)
	
func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)

func emit_player_damaged(damage_amount: float):
	player_damaged.emit(damage_amount)

func emit_enemy_defeated(number: int):
	enemy_defeated.emit(number)

func emit_enemy_spawned(number: int):
	enemy_spawned.emit(number)
	
func emit_enemy_despawned(number: int):
	enemy_despawned.emit(number)

func emit_boss_spawned():
	boss_spawned.emit()
