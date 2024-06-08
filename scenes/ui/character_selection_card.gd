extends PanelContainer

signal selected

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var character_texture = $%CharacterTexture
@onready var weapon_texture = $%WeaponTexture

var disabled = false

func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)
	
func play_in(delay: float = 0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("in")
	
func play_discarded():
	$AnimationPlayer.play("discarded")

func set_character_selection_data(character: Character):
	name_label.text = character.name
	description_label.text = character.description
	character_texture.texture = character.character_sprite
	weapon_texture.texture = character.weapon_upgrade.sprite
	
func select_card():
	disabled = true
	$AnimationPlayer.play("selected")
	
	for other_card in get_tree().get_nodes_in_group("character_card"):
		if other_card == self:
			continue
		other_card.play_discarded()

	await $AnimationPlayer.animation_finished
	selected.emit()

func on_gui_input(event: InputEvent):
	if disabled:
		return
	if event.is_action_pressed("left_click"):
		select_card()

func on_mouse_entered():
	if disabled:
		return
	$HoverAnimationPlayer.play("hover")
