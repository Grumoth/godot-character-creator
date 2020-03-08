extends Node
var savePathPreset:String = "res://Presets/"
var savePathCharacter:String = "res://SavedCharacter/"
var ext:String = ".save"
func _ready():
	pass

func _saveCharacter(n:String,data:Dictionary):
	var fileSave = File.new()
	fileSave.open(savePathCharacter+n+ext,File.WRITE)
	fileSave.store_line(to_json(data))
	
func _loadCharacter(n):
	var fileSave = File.new()
	fileSave.open(savePathCharacter+n+ext,File.READ)
	var charData:Dictionary = parse_json(fileSave.get_line())
	return charData


func _savePreset(n:String,data:Dictionary):
	var fileSave = File.new()
	fileSave.open(savePathPreset+n+ext,File.WRITE)
	fileSave.store_line(to_json(data))
	
func _loadPreset(n):
	var fileSave = File.new()
	fileSave.open(savePathPreset+n+ext,File.READ)
	var charData:Dictionary = parse_json(fileSave.get_line())
	return charData

