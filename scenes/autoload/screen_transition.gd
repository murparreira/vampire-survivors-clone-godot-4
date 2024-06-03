extends CanvasLayer

signal transitioned_halfway
var skip_emit = false

func emit_transitioned_halfway():
	if skip_emit:
		skip_emit = false
		return
	transitioned_halfway.emit()

func transition():
	$AnimationPlayer.play("default")
	await transitioned_halfway
	$AnimationPlayer.play_backwards("default")
