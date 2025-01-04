extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in $VBoxContainer.get_children():
		$VBoxContainer.remove_child(i)
	for i in Global.highscores:
		var TextNode = RichTextLabel.new()
		$VBoxContainer.add_child(TextNode)
		TextNode.text=	i["name"]+"\t\t\t\t"+str(i["score"])
		TextNode.fit_content=true
		TextNode.scroll_active=false
	pass # Replace with function body.
