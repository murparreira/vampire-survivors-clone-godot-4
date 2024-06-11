extends CanvasLayer

var options_scene = preload("res://scenes/ui/options_menu.tscn")

func _ready():
	$%PlayButton.pressed.connect(on_play_pressed)
	$%OptionsButton.pressed.connect(on_options_pressed)
	$%QuitButton.pressed.connect(on_quit_pressed)

func on_play_pressed():
	SceneManager.swap_scenes("res://scenes/ui/character_selection_screen.tscn", get_tree().root, self, "fade_to_black")

func on_options_pressed():
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))
	
func on_quit_pressed():
	get_tree().quit()

func on_options_closed(options_instance: Node):
	options_instance.queue_free()
