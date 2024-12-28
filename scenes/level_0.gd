extends Node2D


func _input(event):
	if event.is_action_pressed("pause"):
		if not get_tree().paused:
			get_node("/root/Level/pause_screen").visible = true
			get_tree().paused = true
