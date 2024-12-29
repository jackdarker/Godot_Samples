extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var node=get_node("CanvasLayer/MarginContainer/VBoxContainer/btStart")
	node.grab_focus()

func _on_bt_focus_entered() -> void:
	$SoundSelect.playing = true

func _on_bt_quit_pressed() -> void:
	pass # Replace with function body.


func _on_bt_start_pressed() -> void:
	Global.goto_scene("res://scenes/Level_0.tscn")
