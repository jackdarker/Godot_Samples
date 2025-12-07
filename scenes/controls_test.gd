extends Window
## Note: disable "embed subwindows" in project settings or min/maximize button wont show


@onready var SceneListItem = load("res://scenes/ImageListItem.tscn")
var UID:int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func saveData()->Dictionary:
	var data ={
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"UID":UID,
		"x":position.x,
		"y":position.y,
	}
	return data

func loadData(data: Dictionary):
	position.x = data["x"]
	position.y = data["y"]
	UID=data["UID"]

func _on_button_pressed() -> void:
	%FileDialog.popup_centered_ratio()

func _on_file_dialog_file_selected(path: String) -> void:
	# Load an image of any format supported by Godot from the filesystem.
	var image = Image.load_from_file(path)
	image.resize(100,100)
	var texture = ImageTexture.create_from_image(image)
	#texture.set_size_override(Vector2(100,100))
	%TextureRect.texture=texture
	
func _on_button_2_pressed() -> void:
	_clearImgList()
	var dir = DirAccess.open("d:/temp")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				if _IsSupportedImage(file_name):
					_loadImgToList(dir.get_current_dir().path_join(file_name))
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")

func _IsSupportedImage(file_name)->bool:
	match file_name.get_extension().to_lower() :
		"png","jpg","jpeg","tga","webp":
			return(true)
		"svg":
			return(false)	
		_:
			return(false)
	
func _displayImage(path)->void:	
	%TextureRect.texture=_loadImgToTexture(path,%TextureRect.size.x,%TextureRect.size.y)

func _loadImgToTexture(path,max_width,max_height)->ImageTexture:
	var m_ImageScalingMode=-1
	var image = Image.load_from_file(path)
	var ImageWidth=image.get_width()
	var ImageHeight=image.get_height()
	var Ratio_W = max_width/ImageWidth
	var Ratio_H = max_height/ImageHeight
	var scale = min(Ratio_W, Ratio_H);
	if ((m_ImageScalingMode == -1) || (m_ImageScalingMode == -2 && scale < 1)):
		image.resize(snapped(ImageWidth * scale,2),snapped(ImageHeight * scale,2))
	elif ((1 <= m_ImageScalingMode) && (m_ImageScalingMode <= 1000)):
		image.resize(snapped((ImageWidth * m_ImageScalingMode) / 100.0,2),snapped((ImageHeight * m_ImageScalingMode) / 100.0,2))
	else:
		pass
	var texture = ImageTexture.create_from_image(image)
	return(texture)

func _loadImgToList(path)->void:
	var _Item=SceneListItem.instantiate()
	var image = Image.load_from_file(path)
	var ThumbnailSize = 128
	var Width =0
	var Height = 0
	var Ratio = image.get_width() / float(image.get_height())
	if Ratio>= 1.0:
		Width = ThumbnailSize;
		Height = (Width * image.get_height()) / float(image.get_width());
	else:
		Height = ThumbnailSize;
		Width = (Height * image.get_width()) / float(image.get_height());

	image.resize(Width,Height)
	var texture = ImageTexture.create_from_image(image)
	_Item.get_node("TextureRect").texture=texture
	_Item.get_node("Label").text=path
	_Item.selected.connect(_displayImage)
	%ImageList.get_child(0).add_child(_Item)

func _clearImgList()->void:
	var node=%ImageList.get_child(0)
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func _clearDirTree(item:TreeItem)->void:
	if item:
		for n in item.get_children():
			n.free()
	else:
		%Tree.clear()

func _on_button_3_pressed() -> void:
	_clearDirTree(null)
	var tree=%Tree
	var root = tree.create_item()
	tree.hide_root = false
	root.set_text(0,"d:/temp")
	root.set_metadata(0,"d:/temp")
	_appendDir(root)
	
func _appendDir(item: TreeItem)->void:
	if !is_inside_tree():
		return
	var tree=%Tree
	var full_path:String=item.get_metadata(0)
	var dir = DirAccess.open(full_path)
	if dir:
		_clearDirTree(item)
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				var node=tree.create_item(item)
				node.set_text(0,file_name)
				node.set_metadata(0,dir.get_current_dir().path_join(file_name))
				tree.create_item(node)
				node.collapsed=true
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")

func _fetchImages(dir_path)->void:
	_clearImgList()
	var dir = DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				if _IsSupportedImage(file_name):
					_loadImgToList(dir.get_current_dir().path_join(file_name))
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")

func _on_tree_item_collapsed(item: TreeItem) -> void:
	if item.collapsed:
		return
	call_deferred("_appendDir",item)	#if called directly tree.create_item(item) returns null?!

func _on_tree_item_selected() -> void:
	var item=%Tree.get_selected()
	_fetchImages(item.get_metadata(0))


func _on_close_requested() -> void:
	hide()
	call_deferred("free")
	pass # Replace with function body.


func _on_button_4_pressed() -> void:
	SaveLoadMgr.save("c://temp//savegame.save")


func _on_button_5_pressed() -> void:
	SaveLoadMgr.load("c://temp//savegame.save")
