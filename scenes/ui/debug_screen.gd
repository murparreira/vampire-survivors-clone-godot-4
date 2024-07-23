extends CanvasLayer

@onready var remove_all_enemies_button: Button = %RemoveAllEnemiesButton
@onready var reset_scene_button: Button = %ResetSceneButton
@onready var god_mode_button: Button = %GodModeButton
@onready var level_up_button: Button = %LevelUpButton
@onready var spawn_boss_button: Button = %SpawnBossButton

func _ready() -> void:
	if OS.is_debug_build():
		self.visible = true
		remove_all_enemies_button.pressed.connect(on_remove_all_enemies_button_pressed)
		reset_scene_button.pressed.connect(on_reset_scene_button_pressed)
		god_mode_button.pressed.connect(on_god_mode_button_pressed)
		level_up_button.pressed.connect(on_level_up_button_pressed)
		spawn_boss_button.pressed.connect(on_spawn_boss_button_pressed)

func _input(event: InputEvent) -> void:
	if OS.is_debug_build():
		if event.is_action_pressed("reset_scene"):
			on_reset_scene_button_pressed()
		if event.is_action_pressed("god_mode"):
			on_god_mode_button_pressed()
		if event.is_action_pressed("remove_all_enemies"):
			on_remove_all_enemies_button_pressed()
		if event.is_action_pressed("level_up"):
			on_level_up_button_pressed()
		if event.is_action_pressed("spawn_boss"):
			on_spawn_boss_button_pressed()

func on_remove_all_enemies_button_pressed():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.queue_free()
	
func on_level_up_button_pressed():
	pass
	
func on_reset_scene_button_pressed():
	get_parent().queue_free()
	SceneManager.swap_scenes("res://scenes/ui/cutscene/cutscene.tscn", get_tree().root, self, "fade_to_black")	
	
func on_god_mode_button_pressed():
	GameData.god_mode = !GameData.god_mode

func on_spawn_boss_button_pressed():
	GameEvents.emit_boss_spawned()
