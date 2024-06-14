extends Node2D

@export var w_chunk: PackedScene
@export var n_chunk: PackedScene
@export var ne_chunk: PackedScene
@export var c_chunk: PackedScene
@export var e_chunk: PackedScene
@export var s_chunk: PackedScene
@export var nw_chunk: PackedScene
@export var se_chunk: PackedScene
@export var sw_chunk: PackedScene

const CHUNK_SIZE = 64

var rendered_coordinates = []
var chunks_array = []
var initial_map_coordinate = Vector2(0,0)

func _ready():
	chunks_array = [
		#c_chunk,
		e_chunk,
		#n_chunk,
		s_chunk,
		#w_chunk,
		#ne_chunk,
		nw_chunk,
		se_chunk,
		sw_chunk,
	]
	rendered_coordinates.append(initial_map_coordinate)
	render_surrounding_chunks(initial_map_coordinate)

func render_surrounding_chunks(map_coordinate: Vector2) -> void:
	var coordinates_to_render = []

	print("Rendering Chunks surrounding: " + str(map_coordinate.x) + ", " + str(map_coordinate.y))
	coordinates_to_render.append(map_coordinate + Vector2(1, 0))
	coordinates_to_render.append(map_coordinate + Vector2(1, 1))
	coordinates_to_render.append(map_coordinate + Vector2(1, -1))
	coordinates_to_render.append(map_coordinate + Vector2(0, 1))
	coordinates_to_render.append(map_coordinate + Vector2(0, -1))
	coordinates_to_render.append(map_coordinate + Vector2(-1, 0))
	coordinates_to_render.append(map_coordinate + Vector2(-1, 1))
	coordinates_to_render.append(map_coordinate + Vector2(-1, -1))
	print("Coordinates to render chunks: " + str(coordinates_to_render))

	for coordinate in coordinates_to_render:
		if rendered_coordinates.find(coordinate) != -1:
			continue
		var chunk_scene = chunks_array.pick_random()
		var chunk_instance = chunk_scene.instantiate()
		chunk_instance.map_coordinate = coordinate
		chunk_instance.connect("player_entered", Callable(self, "on_player_entered_chunk"))
		chunk_instance.global_position = Vector2(coordinate.x * CHUNK_SIZE, coordinate.y * CHUNK_SIZE)
		self.call_deferred("add_child", chunk_instance)
		rendered_coordinates.append(coordinate)
	
	print("Rendered coordinates: " + str(rendered_coordinates))
	coordinates_to_render.append(map_coordinate)
	var distant_coordinates = difference(rendered_coordinates, coordinates_to_render)
	print("Most distant coordinates: " + str(distant_coordinates))

	#var map_chunks = get_tree().get_nodes_in_group("map_chunk")
	#for coordinate in distant_coordinates:
		#for map_chunk in map_chunks:
			#if map_chunk.map_coordinate == coordinate:
				#map_chunk.queue_free()
	
func difference(arr1, arr2):
	var only_in_arr1 = []
	for v in arr1:
		if not (v in arr2):
			only_in_arr1.append(v)
	return only_in_arr1

func on_player_entered_chunk(map_coordinate: Vector2) -> void:
	render_surrounding_chunks(map_coordinate)

