extends Node2D
@onready var coin_effect: AudioStreamPlayer2D = $CoinEffect

func _on_area_2d_area_entered(_area: Area2D) -> void:
	queue_free() 
