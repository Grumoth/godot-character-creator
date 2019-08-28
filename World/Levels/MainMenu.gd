extends Spatial

func _ready():
	_createButtons()
	if GameInstance.currentPlayer:
		$GUI/P/List.get_node(GameInstance.currentPlayer.characterData.name).emit_signal("pressed")
		
	
func _createButtons():
#https://godotengine.org/qa/5175/how-to-get-all-the-files-inside-a-folder
	var characterList = []
	var dir = Directory.new()
	dir.open("res://SavedCharacter")
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file=="":
			break
		elif not file.begins_with("."):
			characterList.append(file.split(".")[0])
	dir.list_dir_end()
	for file in characterList:
		var bt = Button.new()
		bt.text=file
		bt.name=file
		bt.connect("pressed",self,"_spawnCharacter",[file])
		$GUI/P/List.add_child(bt)
		
func _spawnCharacter(n:String):
	GameInstance._spawnPlayer(n)
	$CameraMenu.character=GameInstance.currentPlayer
	$CameraMenu.translation = $CameraMenu.initPos
	$CameraMenu._setZoomTarget()
	$GUI/vb/Label.text = GameInstance.currentPlayer.characterData.name
	$GUI/vb.show()

func _on_btNew_pressed():
	GameInstance._changeScene("res://World/Levels/CharacterCreator.tscn")



func _on_btPlay_pressed():
	GameInstance._changeScene("res://World/Levels/LevelTest.tscn")
	GameInstance._spawnPlayer(GameInstance.currentPlayer.characterData.name)
