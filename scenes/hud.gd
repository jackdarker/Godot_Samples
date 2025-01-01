extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.score=0
	Global.connect("score_changed", Callable(self , "_on_score_changed"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_score_changed(change)-> void:
	$Score.text=str(Global.score)
