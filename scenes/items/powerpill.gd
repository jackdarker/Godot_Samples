extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func pickup(body:BaseCharacter)->void:
	self.visible=false
	$CollisionShape2D.disabled=true
	#self.process_mode=Node.PROCESS_MODE_DISABLED
	Global.scoreChange(50,1)
	Global.scare.emit(true)
	$Timer.stop() 
	$Timer.start(6)
	AudioManager.play_sound(AudioManager.COIN_PICK,0,1) #$SoundPowerup.play()

func _on_sound_pickup_finished() -> void:
	pass #queue_free()


func _on_timer_timeout() -> void:
	$SoundPowerup.stop()
	Global.scare.emit(false)
	queue_free()
