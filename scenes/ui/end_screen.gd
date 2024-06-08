extends CanvasLayer

class_name EndScreen

@onready var panel_container = $%PanelContainer

func _ready():
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	get_tree().paused = true
	$%RestartCharacterButton.pressed.connect(on_restart_character_button_pressed)
	$%MainMenuButton.pressed.connect(on_main_menu_button_pressed)
	$%QuitButton.pressed.connect(on_quit_button_pressed)

func play_jingle(defeat: bool = false):
	if defeat:
		$DefeatJingle.play()
	else:
		$VictoryJingle.play()

func set_defeat_labels_and_play_jingle():
	$%TitleLabel.text = "DEFEAT"
	$%SubtitleLabel.text = "YOU DIED!"
	play_jingle(true)

func on_restart_character_button_pressed():
	get_tree().paused = false
	MusicPlayer.stop()
	BossMusicPlayer.stop()
	SceneManager.swap_scenes("res://scenes/ui/character_selection_screen.tscn", get_tree().root, self.get_parent(), "fade_to_black")
	MenuMusicPlayer.play()
	
func on_main_menu_button_pressed():
	get_tree().paused = false
	MusicPlayer.stop()
	BossMusicPlayer.stop()
	SceneManager.swap_scenes("res://scenes/ui/main_menu.tscn", get_tree().root, self.get_parent(), "fade_to_black")
	MenuMusicPlayer.play()

func on_quit_button_pressed():
	get_tree().quit()
