extends CanvasLayer

func _ready() -> void:
	visible = false
	
func _input(event):
	if visible!=true:	
		#there are multiple overlays with process="when paused" and even if they are not visible, they would still react to the event
		#f.e. when ready_counter is shown 
		return
	if event.is_action_released("pause"):
		_on_bt_resume_pressed()
		get_viewport().set_input_as_handled() # stop propagation to level

func _on_bt_focus_entered() -> void:
	get_node("SoundSelect").playing = true

func _on_bt_resume_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_bt_quit_pressed() -> void:
	Global.goto_scene("res://Scenes/main_menu.tscn")
	#get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_bt_load_pressed() -> void:
	SaveLoad.load_game()
	$Popup.show()


func _on_bt_save_pressed() -> void:
	SaveLoad.save_game()
	$Popup.show()


func _on_bt_OK_pressed() -> void:
	$Popup.hide()
