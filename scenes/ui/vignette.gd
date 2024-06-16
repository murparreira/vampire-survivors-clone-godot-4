extends CanvasLayer

func _ready():
	GameEvents.player_damaged.connect(on_player_damaged)

func on_player_damaged(damage_amount: float):
	if damage_amount > 0:
		$AnimationPlayer.play("hit")
	else:
		$AnimationPlayer.play("heal")
