extends Node2D

@onready var pontuacao: Label = $Pontuacao

func _ready():
	pontuacao.text = str(ScoreManager.score) + " Pontos"
	if(Input.is_anything_pressed()):
		get_tree().change_scene_to_file("res://world.tscn")
	
