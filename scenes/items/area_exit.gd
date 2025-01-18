extends Area2D

@onready var label = $Label
@export_file var next_scene : String
@export var requires_confirm:bool=true	#if true the transfer will only start if player confirms

func _ready():
	self.connect("body_entered", Callable(self, "_on_body_entered"))
	self.connect("body_exited", Callable(self, "_on_body_exited"))
	label.visible = false

#Load the next selected scene as the player presses 'Enter'
func _process(_delta):
	if(Input.is_action_just_pressed("action_1") and label.visible == true):
		Global.goto_scene(next_scene)

#Show or hide the label as the player enters and exits the area
func _on_body_entered(body):
	if body.is_in_group("Player"):
		if(requires_confirm==true):
			label.visible = true
		else:
			Global.goto_scene(next_scene)	#skip showing label

func _on_body_exited(body):
	if body.is_in_group("Player"):
		label.visible = false
