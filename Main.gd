extends Node2D

signal game_tick

const INITIAL_NUMBER_OF_PELLETS = 10

var pellet_scene = load("res://Pellet.tscn")

func _ready():
	for _x in range(INITIAL_NUMBER_OF_PELLETS):
		spawn_pellet()


func _on_game_tick():
	emit_signal("game_tick")
	spawn_pellet()


func spawn_pellet():
	randomize()
	if randf() * 100 < 10:
		add_child(pellet_scene.instance())
