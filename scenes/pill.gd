extends Area2D


func pickup()->void:
	self.visible=false
	$SoundPickup.play()
	Global.scoreChange(10)
	#queue_free()  this would stop the sound


#func _on_sound_pickup_finished() -> void:
#	queue_free()
