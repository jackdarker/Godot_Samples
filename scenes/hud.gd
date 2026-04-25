extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("score_changed", Callable(self , "_on_score_changed"))
	Global.mode_change.connect(get_node("/root/Level").enter_mode)

func _on_score_changed(_change)-> void:
	$Score.text=str(Global.score)
	$Bonus.text=str(Global.Bonus)
	$ProgressBar.max_value=100
	$ProgressBar.value=Global.pills


func _on_bt_mode_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.mode_change.emit(Global.MODE.BUILD)
	else:
		Global.mode_change.emit(Global.MODE.SIM)


func _on_bt_floor_1x_4_pressed() -> void:
	pass # Replace with function body.
