extends CharacterBody2D

@onready var anim = get_node("AnimatedSprite2D")
@onready var initial_position = position

const SPEED = 100.0
var lives = 1 #Pac-man lives counter

const PPill = preload("res://scenes/powerpill.gd")

func _physics_process(_delta: float) -> void:
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	velocity.x=0
	velocity.y=0
	if direction_x:
		velocity.x = direction_x * SPEED
		velocity.y = 0
		if direction_x > 0:
			anim.play("right")
		if direction_x < 0:
			anim.play("left")
	elif direction_y:
		velocity.x = 0
		velocity.y = direction_y * SPEED
		if direction_y > 0:
			anim.play("down")
		if direction_y < 0:
			anim.play("up")
	move_and_slide()
	
func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	#print("hit3")
	if area.is_in_group("Items"):
		if(area is PPill):
			pass #$SoundPowerup.play()
		area.pickup()
	elif area.is_in_group("Ghosts"):
		var _foe=area.get_parent()
		if(_foe.Mode==Global.MODE.FRIGHTENED):
			_foe.kill()
		elif(_foe.Mode==Global.MODE.RUN):
			pass
		else:
			Global.player_death.emit()
			#character_reset()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	var faction:int=body.get_meta("faction",0)
	if(faction!=0):
		pass #character_reset()

func revive() -> void:
	position = initial_position
	# Lives counter
	lives = lives - 1

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y
	}
	return save_dict
