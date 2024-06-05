extends CanvasLayer

@export var experience_manager: ExperienceManager
@onready var progress_bar = $%ProgressBar
@onready var level_label = %LevelLabel
@onready var kill_count_label = %KillCountLabel
@onready var enemies_count_label = %EnemiesCount

func _ready():
	if !get_tree().debug_collisions_hint:
		enemies_count_label.visible = false
	progress_bar.value = 0
	experience_manager.experience_updated.connect(on_experience_updated)
	experience_manager.level_up.connect(on_level_up)
	GameEvents.enemy_defeated.connect(on_enemy_defeated)
	GameEvents.enemy_spawned.connect(on_enemy_spawned)
	GameEvents.enemy_despawned.connect(on_enemy_despawned)

func on_experience_updated(current_experience: float, target_experience: float):
	var percent = current_experience / target_experience
	progress_bar.value = percent

func on_level_up(new_level: int):
	level_label.text = "Lvl. " + str(new_level)

func on_enemy_defeated(kill_count: int):
	kill_count_label.text = str(int(kill_count_label.text) + kill_count)

func on_enemy_spawned(spawn_count):
	enemies_count_label.text = str(int(enemies_count_label.text) + spawn_count)
	
func on_enemy_despawned(despawn_count):
	enemies_count_label.text = str(int(enemies_count_label.text) - despawn_count)
