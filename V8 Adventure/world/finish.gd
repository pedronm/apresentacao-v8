extends Node2D

signal finish()


func _on_area_2d_area_entered(area: Area2D) -> void:
	finish.emit()
