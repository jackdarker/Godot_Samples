extends CanvasLayer


var count:int=3

func _ready() -> void:
	count=3
	$Label.text=str(count)
	visible = true
	get_tree().paused = true
	
func _on_timer_timeout() -> void:
	if(count>0):
		count-=1
		$Label.text=str(count)
	else:
		visible = false
		get_tree().paused = false
		$Timer.stop()
