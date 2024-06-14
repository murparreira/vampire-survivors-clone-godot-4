extends Node2D

signal player_entered(map_coordinate)

@onready var area_2d = $PlayerDetection as Area2D

const TYPE = 'dirt'
const CHUNK_SIZE = 64
var map_coordinate

func _ready():
	area_2d.body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D) -> void:
	if body is TileMap:
		return
	print("Body entered: " + str(body.name) + " Coordinate: " + str(map_coordinate.x) + "/" + str(map_coordinate.y))  # Debugging statement
	emit_signal("player_entered", map_coordinate)
