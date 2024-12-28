extends CanvasLayer

func _ready() -> void:
	visible = false
	
func _input(event):
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			visible = false
			get_tree().paused = false
			print(get_tree().paused)
			
func _on_bt_focus_entered() -> void:
	get_node("SoundSelect").playing = true
	visible = false
	get_tree().paused = false


func _on_bt_resume_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_bt_quit_pressed() -> void:
	pass # Replace with function body.
