extends Node
var popUpPreload = preload("res://scenes/pop_up.tscn")
var tutorialNodepPreload = preload("res://scenes/TutorialNode.tscn")

func createPopUp(text:String):
	var popUp:PopUp = popUpPreload.instantiate(); GlobalVars.player.add_child(popUp)
	popUp.setText(text)

func createTutorialNode(text:String, newActionNeeded:String):
	var tutorialNode = tutorialNodepPreload.instantiate(); GlobalVars.player.add_child(tutorialNode)
	tutorialNode.constructor(text,newActionNeeded)
	
