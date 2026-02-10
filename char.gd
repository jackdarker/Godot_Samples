extends Node

func _ready():
	$AnimationPlayer.clear_queue()

func runAnimation():
	$AnimationPlayer.play("hand_up")
