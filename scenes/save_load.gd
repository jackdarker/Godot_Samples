#class_name SaveData 
extends Node

var save_file_name = "c://temp//save1.txt"#"user://GodotSample.save"
var highscore_name = "c://temp//score.txt"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
	
# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the persist category and ask them to return a
# dict of relevant variables.
func save_game():
	var save_file = FileAccess.open(save_file_name, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)

# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	if not FileAccess.file_exists(save_file_name):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()
	save_nodes[0].free()  #TODO with queue_free the node is still present and the newly created will have different name

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open(save_file_name, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instantiate()
		#Problem: loading "level.tscn" will cause creation of (persistent) sub-items and further loading of sub-items will add more to them
		#Hack: delete persistent, pre-instantiated sub-items before loading them
		
		#Problem: a Node has a parent but also references to other nodes: a homing-missiles parent is Foe#1 and its "target" is Player#2
		# when restoring a Node, referenced Nodes might not yet be available
		#Hack: all persitent Nodes have UID and on save this id is stored in dataset:  
		#Missile: {UID:"Mis#1111", parent: "Foe#1", target: "Player#2"} 
		#Foe: {UID:"Foe#1", projectils:["Mis#1111"]}
		#When restoring Nodes-properties check if referenced Node is already alive, otherwise bookmark as todo
		#when saving Nodes check if referenced node is already saved
		
		#Problem: could cause issue if referenced-nodes need to be present already in _ready
		#Hack: add the nodes only to three after everything is set
		
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
	return

func save_highscore(highscores) -> int:
	var json_string = JSON.stringify(highscores)
	
	var file = FileAccess.open(highscore_name, FileAccess.WRITE)
	if file:
		file.store_line(json_string) #file.store_64(highscore)
		return 0
	else:
		push_warning("Couldn't save highscore file: ", error_string(FileAccess.get_open_error()))
		return -1

func load_highscore(highscores) -> int:
	var json = JSON.new()
	
	var file = FileAccess.open(highscore_name, FileAccess.READ)
	if file:
		var json_string=file.get_line()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			return -1
		# Get the data from the JSON object.
		highscores.assign(json.data)
		return 0 #file.get_64()
	else:
		push_warning("Couldn't load highscore file: ", error_string(FileAccess.get_open_error()))
		return -1
