extends Node

var highscores:Array[Dictionary] = []
var score:int
var pills:int  #pills required

var level:int=2

signal scare(on:bool)	#fired when powerpill pickedup
signal score_changed(change) #fired when score is increased
signal bonus_changed(change) #fired when bonus multiplier increased
signal player_death() 
signal interact_touched(body:Node2D, touched:bool, Message:String) #emitted by interactable to character

func scoreChange(change,pill):
	score+=change
	pills-=pill
	emit_signal("score_changed", change)

var Bonus:int=1

var current_scene = null

enum MODE{SLEEP,CHASE,SCATTER,FRIGHTENED,RUN}

func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	_deferred_goto_scene.call_deferred(path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene.
	current_scene.free()
	# Load the new scene.
	var s = ResourceLoader.load(path)
	# Instance the new scene.
	current_scene = s.instantiate()
	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)
	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	current_scene = root.get_child(-1)
	if(SaveLoad.load_highscore(highscores)<0):
		highscores=[{"name":"Inky","score":10000 },{"name":"Pinky","score":5000 }]
		SaveLoad.save_highscore(highscores)

func quitGodot():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
	
func updateHighscore():	
	var index:int=-1
	var maxEntrys:int=5
	var entry={"name":"Player","score":Global.score}
	for i in Global.highscores.size():
		if(Global.score>Global.highscores[i]["score"]):
			index=i
			break
	if(index>=0):
		Global.highscores.insert(index,entry)
		if(Global.highscores.size()>maxEntrys):
			Global.highscores.resize(maxEntrys)
		SaveLoad.save_highscore(Global.highscores)
	elif(Global.highscores.size()<maxEntrys):
		Global.highscores.append(entry)
