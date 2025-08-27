extends Node
var popUpPreload = preload("res://scenes/pop_up.tscn")
var tutorialNodepPreload = preload("res://scenes/TutorialNode.tscn")

func createPopUp(text:String, size:int = 1, speedScale:float = 1):
	var popUp:PopUp = popUpPreload.instantiate(); GlobalVars.player.add_child(popUp); 
	popUp.animPlayer.speed_scale = speedScale
	popUp.global_position.y -= (size-1)*10
	popUp.setText(text)

func createTutorialNode(text:String, newActionNeeded:String):
	var tutorialNode = tutorialNodepPreload.instantiate(); GlobalVars.player.add_child(tutorialNode)
	tutorialNode.constructor(text,newActionNeeded)
	
