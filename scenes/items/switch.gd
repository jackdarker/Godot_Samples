extends Area2D

@export_multiline var Message:String = "use me" #
signal switch(on:bool,switch:Node2D)

func _ready() -> void:
	$Sprite/State1.visible=false
	pass # Replace with function body.

func useMe()->void:
	emit_signal("switch", true,self)
	$Sprite/State1.visible=true
	pass

func _on_body_exited(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		Global.interact_touched.emit(self,false,"")
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		Global.interact_touched.emit(self,true,Message)
	pass # Replace with function body.
