extends Node
var popUpPreload = preload("res://scenes/pop_up.tscn")

func createPopUp(text:String):
	var popUp:PopUp = popUpPreload.instantiate(); GlobalVars.player.add_child(popUp)
	popUp.setText(text)
