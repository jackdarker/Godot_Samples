extends Area2D

@export_multiline var Message:String = "use me" #
@export var target_floor:int =1

signal switch(new_floor:int)

func _ready() -> void:
	$Sprite/Closed.visible=true

func useMe()->void:
	emit_signal("switch", target_floor)
	$Sprite/Closed.visible=true

func _on_body_exited(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		Global.interact_touched.emit(self,false,"")
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Player")):
		Global.interact_touched.emit(self,true,Message)
	pass # Replace with function body.
