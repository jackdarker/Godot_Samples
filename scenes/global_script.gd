extends Node

var save_file = "user://GodotSample.save"
var score:int=0

signal score_changed(change)
func scoreChange(change):
	score+=change
	emit_signal("score_changed", change)
	
var current_scene = null

enum MODE{CHASE,SCATTER,FRIGHTENED}

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func quitGodot():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
	