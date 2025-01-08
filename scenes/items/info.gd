extends Area2D

# shows a text notification when touched by player
enum TriggerMode {COLLIDE=1, ACTION=2}
@export_multiline var Message:String = "show this text" #
@export var Trigger:TriggerMode = TriggerMode.COLLIDE

func _ready() -> void:
	$Sprite/Mark.visible=true
	$Sprite/Info.visible=false
	
	pass # Replace with function body.

func trigger_on()->void:
	$Sprite/Info.size
	$Sprite/Info.text=Message
	$Sprite/Mark.visible=false
	$Sprite/Info.visible=true
	
func trigger_off()->void:
	$Sprite/Mark.visible=true
	$Sprite/Info.visible=false


func _on_body_exited(body: Node2D) -> void:
	trigger_off()
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	trigger_on()
	pass # Replace with function body.
