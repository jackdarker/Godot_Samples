extends Area2D


func pickup()->void:
	self.visible=false
	self.process_mode=Node.PROCESS_MODE_DISABLED
	$SoundPickup.play()
	Global.scoreChange(10,1)
	#queue_free()  this would stop the sound


#func _on_sound_pickup_finished() -> void:
#	queue_free()

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y
	}
	return save_dict
