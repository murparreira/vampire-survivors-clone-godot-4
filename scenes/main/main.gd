extends Node

@export var end_screen_scene: PackedScene

var pause_menu_scene = preload("res://scenes/ui/pause_menu.tscn")
@onready var player = $%Player
@onready var upgrade_manager = $UpgradeManager

func _ready():
	BossMusicPlayer.stop()
	MenuMusicPlayer.stop()
	MusicPlayer.play()
	player.sprite.texture = GameData.character.character_sprite
	player.health_component.died.connect(on_player_died)
	upgrade_manager.apply_upgrade(GameData.character.weapon_upgrade)

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()

func on_player_died():
	MetaProgression.add_statistics_to_save_data("loss_total_count", 1)
	var end_screen_instance = end_screen_scene.instantiate() as EndScreen
	add_child(end_screen_instance)
	end_screen_instance.set_defeat_labels_and_play_jingle()

