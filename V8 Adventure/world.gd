extends Node2D

@onready var score_label: Label = $UI/ScoreLabel
@onready var audio: AudioStreamPlayer2D = $Audio
@onready var coin_effect: AudioStreamPlayer2D = $CoinEffect

var end_scene = preload("res://scenes/finish_line.tscn")

var score = 0:
	get:
		return score
	set(value):
		score = value
		score_label.text = "Score :" + str(score)

func _ready():
	if(!audio.playing):
		audio.play()
	score += 0

func _on_player_coined() -> void:
	score += 100
	coin_effect.play()
	

func _on_player_died() -> void:
	get_tree().change_scene_to_file("res://world.tscn")

func _on_finish_finish() -> void:
	ScoreManager.score = score
	var instantiated = end_scene.instantiate()
	var tree = get_tree()
	var curr_scene = tree.get_current_scene()
	tree.get_root().add_child(instantiated)
	tree.get_root().remove_child(curr_scene)
	tree.set_current_scene(instantiated)
