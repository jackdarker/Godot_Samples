extends Node
@onready var edit_ui = $Panel
@onready var place_btn = $Panel/VBox/btn_place
@onready var select_btn = $Panel/VBox/btn_select
@onready var move_btn = $Panel/VBox/btn_move
@onready var rotate_btn = $Panel/VBox/btn_rotate
@onready var delete_btn = $Panel/VBox/btn_delete
#@onready var edit_toggle = $EditorUI/Panel/VBox/EditToggle
#snap_spin = $EditorUI/Panel/VBox/SnapHBox/SnapSpin
@onready var save_btn = $Panel/VBox/btn_save
@onready var load_btn = $Panel/VBox/btn_load

var current_tool: String = "place" # "place","select","move","rotate","delete"
var snap_size: int = 64
var selected_node: Node2D = null
var room_scene: PackedScene = load("res://scenes/level_editor/room4x4.tscn")
var floor_scene: PackedScene = load("res://scenes/level_editor/floor1x4.tscn")

var ghost: Node2D = null
var dragging: bool = false
var drag_offset := Vector2.ZERO

func _ready():
	# Wire UI
	#edit_toggle.pressed = false
	#edit_toggle.connect("pressed", Callable(self, "_on_edit_toggle_pressed"))
	place_btn.pressed.connect(_on_tool_pressed.bind("place"))
	select_btn.pressed.connect(_on_tool_pressed.bind("select"))
	move_btn.pressed.connect(_on_tool_pressed.bind("move"))
	rotate_btn.pressed.connect(_on_tool_pressed.bind("rotate"))
	delete_btn.pressed.connect(_on_tool_pressed.bind("delete"))
	#snap_spin.connect("value_changed", Callable(self, "_on_snap_changed"))
	save_btn.pressed.connect(_on_save_pressed)
	load_btn.pressed.connect(_on_load_pressed)
	# Create ghost node container
	ghost = Node2D.new()
	ghost.visible = false
	add_child(ghost)
	self.visible=false

func _on_tool_pressed(tool):
	current_tool = tool
	_update_tool_buttons(tool)

func _update_tool_buttons(active):
	# visual feedback
	for b:Button in [place_btn, select_btn, move_btn, rotate_btn, delete_btn]:
		b.button_pressed = b.text.to_lower() == active

func _on_snap_changed(value):
	snap_size = int(value)

func world_mouse_pos() -> Vector2:
	var cam := get_viewport().get_camera_2d()
	if cam:
		return cam.get_global_mouse_position()
	return world_mouse_pos() # get_global_mouse_position()

func snap_pos(p: Vector2) -> Vector2:
	var s = snap_size
	return Vector2(round(p.x / s) * s, round(p.y / s) * s)

func _unhandled_input(event):
	if not Global.editing:
		return
	if event is InputEventMouseMotion and dragging and current_tool == "move" and selected_node:
		var pos = snap_pos(world_mouse_pos() + drag_offset)
		selected_node.position = pos
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mp = world_mouse_pos()
		var pos = snap_pos(mp)
		match current_tool:
			"place":
				_place_node_at(pos)
			"select":
				_select_at(mp)
			"move":
				_start_or_select_move(mp)
			"rotate":
				_rotate_at(mp)
			"delete":
				_delete_at(mp)
	if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if dragging:
			dragging = false

func _place_node_at(pos: Vector2):
	# Default to placing a Room; you could add UI to pick type
	var scene = room_scene
	if not scene:
		return
	var inst = scene.instantiate()
	inst.position = pos
	var entities = get_node("/root/Level/level_data")
	entities.add_child(inst)

func _select_at(world_pos: Vector2):
	var picked = _pick_node_at(world_pos)
	selected_node = picked
	_update_selection_visual()

func _start_or_select_move(world_pos: Vector2):
	var picked = _pick_node_at(world_pos)
	if picked:
		selected_node = picked
		drag_offset = selected_node.global_position - world_pos
		dragging = true
		_update_selection_visual()
	else:
		selected_node = null
		_update_selection_visual()

func _rotate_at(world_pos: Vector2):
	var picked = _pick_node_at(world_pos)
	if picked:
		picked.rotation_degrees = int(picked.rotation_degrees / 90 + 1) * 90

func _delete_at(world_pos: Vector2):
	var picked = _pick_node_at(world_pos)
	if picked:
		picked.queue_free()
	if selected_node == picked:
		selected_node = null

func _pick_node_at(world_pos: Vector2) -> Node2D:
	# check Entities children from top to bottom
	var entities = get_node("/root/Level/level_data")
	var children = entities.get_children()
	for i in range(children.size() - 1, -1, -1):
		var c = children[i]
		if c is Node2D:
			var local = c.to_global(Vector2.ZERO)
			# simple bounding test using sprite rect if available
			if c.has_node("Sprite"):
				var sp = c.get_node("Sprite") as Sprite2D
				var tex = sp.texture
				if tex:
					var rect = Rect2(c.global_position - sp.texture.get_size() * 0.5 * c.scale, sp.texture.get_size() * c.scale)
					if rect.has_point(world_pos):
						return c
					# fallback: distance test
					if c.global_position.distance_to(world_pos) < snap_size * 0.75:
						return c
	return null

func _update_selection_visual():
	# simple highlight by modulating sprite
	var entities = get_node("/root/Level/level_data")
	for c in entities.get_children():
		if c.has_node("Sprite"):
			var sp = c.get_node("Sprite") as Sprite2D
			if c == selected_node:
				sp.modulate = Color(1,0.8,0.4,1)
			else:
				sp.modulate = Color(1,1,1,1)

func _on_save_pressed():
	var entities = get_node("/root/Main/Game/Entities")
	var out = []
	for c in entities.get_children():
		var entry = {
		"scene": c.filename if "filename" in c else "",
		"path": c.filename if "filename" in c else "", # Godot Node2D instances don't expose filename; we'll serialize by type name
		"type": c.name,
		"position": [c.position.x, c.position.y],
		"rotation_degrees": c.rotation_degrees
		}
		# collect custom properties if available
		if c.has_method("editor_serialize"):
			entry["properties"] = c.editor_serialize()
			out.append(entry)
	var dict = {"entities": out}
	var json = JSON.stringify(dict)
	var dir = DirAccess.open("user://levels")
	if not dir:
		DirAccess.make_dir_absolute("user://levels")
	var f = FileAccess.open("user://levels/level1.json", FileAccess.WRITE)
	if f:
		f.store_string(json)
		f.close()
		print("Saved level to user://levels/level1.json")

func _on_load_pressed():
	var path = "user://levels/level1.json"
	if not FileAccess.file_exists(path):
		print("No saved level at ", path)
	return
	var f = FileAccess.open(path, FileAccess.READ)
	if not f:
		return
	var json = f.get_as_text()
	f.close()
	var res = JSON.parse_string(json)
	if res.error != OK:
		print("Failed to parse JSON")
	return
	var data = res.result
	# clear entities
	var entities = get_node("/root/Level/level_data")
	for c in entities.get_children():
		c.queue_free()
	for entry in data.get("entities", []):
		var tname = entry.get("type", "Room")
		var scene: PackedScene = null
		if tname == "Room":
			scene = room_scene
		elif tname == "Floorway":
			scene = floor_scene
		if scene:
			var inst = scene.instantiate()
			inst.position = Vector2(entry["position"][0], entry["position"][1])
			inst.rotation_degrees = entry.get("rotation_degrees", 0)
			# restore properties
			if inst.has_method("editor_deserialize") and entry.has("properties"):
				inst.editor_deserialize(entry["properties"])
			entities.add_child(inst)
