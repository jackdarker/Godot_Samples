extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("score_changed", Callable(self , "_on_score_changed"))

func _on_score_changed(_change)-> void:
	$Score.text=str(Global.score)
	$Bonus.text=str(Global.Bonus)
	$ProgressBar.max_value=100
	$ProgressBar.value=Global.pills
