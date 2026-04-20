class_name Building extends Node2D

@export var data:DataBuilding


func _possible_doors()->Array:
	return($Doors.get_children())

#override for data to save
func editor_serialize()->Dictionary:
	return({})

#override for data to load
func editor_deserialize(_data:Dictionary):
	pass
