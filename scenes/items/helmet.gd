extends Area2D
@export var equipslot:String = "Head" #category "Armor"
@export var equipname:String = "Helmet1" #node with name "Helmet1"

func _ready() -> void:
	var items=$Sprite.get_children();
	for i in items:
		i.visible=(i.name==equipname)
	pass # Replace with function body.


func pickup(body:BaseCharacter)->void:
	var ok=body.equip(equipslot,equipname)
	#var item=body.find_child(equipname)
	#if(item && !item.visible):
	#	item.visible=true
	#	AudioManager.play_sound(AudioManager.ARMOR_PICK,0,1)
	if(ok):
		queue_free()
	else:
		AudioManager.play_sound(AudioManager.NO_PICK,0,1)
		pass	
	
