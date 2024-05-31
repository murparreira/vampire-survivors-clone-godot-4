extends CanvasLayer

@export var arena_time_manager: Node
@onready var label = $%TimerLabel

func _process(delta):
	if arena_time_manager == null:
		return
	var time_ellapsed = arena_time_manager.get_time_ellapsed()
	label.text = format_seconds_to_string(time_ellapsed)
	
func format_seconds_to_string(seconds: float):
	var minutes = floor(seconds / 60)
	var remaining_seconds = seconds - (minutes * 60)
	return str(minutes) + ":" + ("%02d"% floor(remaining_seconds))	
