extends Node

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed():
		var key = event.keycode
		match key:
			KEY_Q:
				get_tree().quit()
			KEY_R:
				get_tree().reload_current_scene()

var star_name:String
