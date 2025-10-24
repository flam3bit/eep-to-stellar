extends Node


func _on_mist_pressed() -> void:
	$Menu.queue_free()
	$CSVToSTP.queue_free()
