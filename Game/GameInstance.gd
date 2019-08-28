extends Node
var currentScene ;var currentPlayer
var nextScene
onready var mainScene = preload("res://World/Levels/MainMenu.tscn")
onready var player = preload("res://MainCharacter/MainCharacter.tscn")
onready var GAME = get_parent().get_node("Game")

func _ready():
	currentScene=mainScene.instance()
	GAME.add_child(currentScene)
	
func _changeScene(path:String):
	nextScene=ResourceLoader.load(path).instance()
	currentScene.queue_free()
	currentScene=nextScene
	GAME.add_child(nextScene)

func _spawnPlayer(n:String):
	if currentPlayer:
		currentPlayer.queue_free()
	currentPlayer = player.instance()
	currentScene.add_child(currentPlayer)
	currentPlayer.characterData=Save._loadCharacter(n)
	currentPlayer._load(currentPlayer.characterData)
	currentPlayer._loadFeatures()
	
	
