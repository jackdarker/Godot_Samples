extends Window
## Note: disable "embed subwindows" in project settings or min/maximize button wont show

signal selected(path:String)

@onready var SceneListItem = load("res://scenes/ImageListItem.tscn")

var UID:int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selected.connect(Global.getGlobalViewer().loadImgToList)


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

var _actual_image=null	
func _displayImage(path)->void:	
	_actual_image=path
	%TextureRect.texture=Global.loadImgToTexture(path,%TextureRect.size.x,%TextureRect.size.y)
	selected.emit(path)

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

func _on_tree_item_collapsed(item: TreeItem) -> void:
	if item.collapsed:
		return
	call_deferred("_appendDir",item)	#if called directly tree.create_item(item) returns null?!

func _on_tree_item_selected() -> void:
	var item=%Tree.get_selected()
	_fetchImagesThreaded(item.get_metadata(0))

var _items:Array=[]
signal item_created(item)
func _fetchImagesThreaded(dir_path)->void:
	_clearImgList()
	item_created.connect(updateList)
	_items=[]
	var task=Global.create_task(fetchImagesByThread.bind(dir_path,_items))
	#task.finished.connect(updateList)

func fetchImagesByThread(dir_path,_Items:Array):
	var dir = DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				if _IsSupportedImage(file_name):
					var path=dir_path.path_join(file_name)
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
					_Items.append(_Item)
					item_created.emit.call_deferred(_Item)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")

func updateList(item):
	item.selected.connect(_displayImage)
	%ImageList.get_child(0).add_child(item)


func updateListAll(taskid):
	for _item in _items:
		_item.selected.connect(_displayImage)
		%ImageList.get_child(0).add_child(_item)

func _on_close_requested() -> void:
	hide()
	call_deferred("free")
	pass # Replace with function body.


func _on_button_4_pressed() -> void:
	SaveLoadMgr.save("c://temp//savegame.save")


func _on_button_5_pressed() -> void:
	SaveLoadMgr.load("c://temp//savegame.save")

func _on_texture_rect_resized() -> void:
	if _actual_image:
		_displayImage(_actual_image)
