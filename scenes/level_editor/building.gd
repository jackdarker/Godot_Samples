class_name Building extends Node2D

@export var data:DataBuilding


func _possible_doors()->Array:
	return($Doors.get_children())
