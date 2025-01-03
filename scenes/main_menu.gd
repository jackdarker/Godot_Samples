extends Node



func _ready() -> void:
	var node=$CanvasLayer/MarginContainer/MenuContainer
	node=node.get_child(0)# /btStart")
	node.grab_focus()

func _on_bt_focus_entered() -> void:
	$SoundSelect.playing = true

func _on_bt_quit_pressed() -> void:
	Global.quitGodot()

func _on_bt_main_pressed() -> void:
	Global.goto_scene("res://Scenes/main_menu.tscn")

func _on_bt_start_pressed() -> void:
	Global.goto_scene("res://scenes/Level_1.tscn")
