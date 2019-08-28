tool
extends VBoxContainer
var type:String
var prop:String
func _ready():
	$sLabel.text=name
	type=name[0]
	prop = name.split("_")[1]

func _on_slider_value_changed(value):
	owner._sliderChange(value,type,prop)
