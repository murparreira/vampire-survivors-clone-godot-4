extends Node

@export var end_screen_scene: PackedScene

var pause_menu_scene = preload("res://scenes/ui/pause_menu.tscn")
@onready var player = $%Player

var character: Character

func _ready():
	BossMusicPlayer.stop()
	MenuMusicPlayer.stop()
	MusicPlayer.play()
	player.sprite.texture = character.character_sprite
	player.abilities.add_child(character.ability_controller.instantiate())
	player.health_component.died.connect(on_player_died)

func receive_data(data):
	character = data["character"]

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()
	
func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate() as EndScreen
	add_child(end_screen_instance)
	end_screen_instance.set_defeat_labels_and_play_jingle()
