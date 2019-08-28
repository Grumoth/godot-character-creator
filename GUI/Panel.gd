extends Panel

func _ready():
	for bt in $vb.get_children():
		if bt.is_class("Button"):
			var btName = bt.name.split("_")
			bt.connect("pressed",self,"_expand",[btName[1]])
		if bt.is_class("VBoxContainer") and bt.name!="body":
			_expand(bt.name)
			
func _expand(which:String):
	for bt in $vb.get_children():
		if bt.is_class("VBoxContainer"):
			bt.visible=false
	var container:VBoxContainer = get_node("vb/"+which)
	container.visible = !container.visible
	
