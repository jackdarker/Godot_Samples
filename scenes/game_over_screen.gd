extends CanvasLayer


func _ready() -> void:
	visible = false
	
func _on_bt_focus_entered() -> void:
	get_node("SoundSelect").playing = true

func _on_bt_resume_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_bt_quit_pressed() -> void:
	Global.goto_scene("res://scenes/main_menu.tscn")
