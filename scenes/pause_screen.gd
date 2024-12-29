extends CanvasLayer

func _ready() -> void:
	visible = false
	
	
func _on_bt_focus_entered() -> void:
	get_node("SoundSelect").playing = true

func _on_bt_resume_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_bt_quit_pressed() -> void:
	Global.goto_scene("res://Scenes/main_menu.tscn")
	#get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_bt_quit_2_pressed() -> void:
	get_node("SoundSelect").playing = true
