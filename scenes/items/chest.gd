extends StaticBody2D

#@export var onUse:Callable = Callable(self, "open")


func _ready() -> void:
	$Sprite/Closed.visible=true
	$Sprite/Open.visible=false
	pass

func setState(open:bool) -> void:
	$Sprite/Closed.visible=false
	$Sprite/Open.visible=true
	AudioManager.play_sound(AudioManager.NO_PICK,0,1)
