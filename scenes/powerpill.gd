extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func pickup()->void:
	self.visible=false
	Global.scoreChange(50)
	Global.scare.emit(true)
	Global.setBonus(4)
	$Timer.stop() 
	$Timer.start(6)
	$SoundPowerup.play()

func _on_sound_pickup_finished() -> void:
	pass #queue_free()


func _on_timer_timeout() -> void:
	$SoundPowerup.stop()
	Global.scare.emit(false)
	queue_free()
