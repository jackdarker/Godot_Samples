extends Node

#Gently bob up and down parent Node2D with 'amplitude' where 'frequency' is speed

var time_passed = 0

@onready var _owner:Node2D=get_parent()
@onready var initial_position=_owner.position
@export var amplitude := 3.0
@export var frequency := 4.0


func _process(_delta):
	body_hover(_delta)

func body_hover(delta):
	time_passed += delta
	var new_y = initial_position.y + amplitude * sin(frequency * time_passed)
	_owner.position.y = new_y
