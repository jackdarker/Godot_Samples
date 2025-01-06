extends Area2D

@onready var label = $Label
@export var next_scene : String

func _ready():
	label.visible = false

#Load the next selected scene as the player presses 'Enter'
func _process(_delta):
	if(Input.is_action_just_pressed("action_1") and label.visible == true):
		Global.goto_scene(next_scene)

#Show or hide the label as the player enters and exits the area
func _on_body_entered(body):
	if body.is_in_group("Player"):
		label.visible = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		label.visible = false
