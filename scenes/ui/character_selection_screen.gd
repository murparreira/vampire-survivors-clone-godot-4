extends CanvasLayer

class_name CharacterSelectionScreen

@export var character_card_scene: PackedScene
@export var character_list: Array[Character]
@onready var card_container: HBoxContainer = $%CardContainer
@onready var back_button = %BackButton

func _ready():
	back_button.pressed.connect(on_back_button_pressed)
	set_characters(character_list)

func set_characters(characters: Array[Character]):
	var delay = 0
	for character in characters:
		var card_instance = character_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_character_selection_data(character)
		card_instance.play_in(delay)
		card_instance.selected.connect(on_character_selected.bind(character))
		delay += .2
	
func on_character_selected(character):
	GameData.character = character
	$AnimationPlayer.play("out")
	await $AnimationPlayer.animation_finished
	SceneManager.swap_scenes("res://scenes/ui/cutscene/cutscene.tscn", get_tree().root, self, "fade_to_black")

func on_back_button_pressed():
	SceneManager.swap_scenes("res://scenes/ui/main_menu.tscn", get_tree().root, self, "fade_to_black")
