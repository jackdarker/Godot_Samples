extends Window

signal sel_changed(String)

@onready var list=$Panel/HFlowContainer

func _ready() -> void:
	for bt:Button in list.get_children():
		bt.pressed.connect(sel_changed.emit.bind(bt.text))

	self.close_requested.connect(hide)
