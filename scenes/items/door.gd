class_name Door extends Area2D
@export_multiline var Message:String = "open door" #

func _ready() -> void:
	$Sprite/Closed.visible=true
	$Sprite/Open.visible=false
	pass

func toggleState()->void:
	self.setState(!$Sprite/Open.visible)

func setState(open:bool) -> void:
	if(open):		#todo when reenabled push char out of way
		$StaticBody2D.process_mode=Node.PROCESS_MODE_DISABLED
	else:
		$StaticBody2D.process_mode=Node.PROCESS_MODE_INHERIT
	$Sprite/Closed.visible=!open
	$Sprite/Open.visible=open
	AudioManager.play_sound(AudioManager.NO_PICK,0,1)

func _on_body_exited(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		Global.interact_touched.emit(self,false,"")
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		Global.interact_touched.emit(self,true,Message)
	pass # Replace with function body.

func useMe()->void:
	self.toggleState()
	pass
