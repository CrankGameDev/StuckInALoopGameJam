extends Control



func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scene.tscn")
	
	
func _on_main_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/start_screen.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
