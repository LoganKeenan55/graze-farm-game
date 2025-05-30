extends Node2D

var tileArray = []
var itemArray = []
var seedArray = []
var mode = ""

@onready var player = find_parent("Player")
func _ready() -> void:
	setArrs()
	
func setArrs(): #sets arrays with sprites and numbers
	var Itemchildren = $ItemsHUD.get_children()
	var count1 = 1
	
	for i in range(Itemchildren.size()): #for Items
		if $ItemsHUD.get_child(i).get_script() == preload("res://hot_bar_item.gd"):  
			itemArray.append($ItemsHUD.get_child(i))
			$ItemsHUD.get_child(i).number.text = str(count1)
			count1 += 1
		
		
	var Tileschildren = $TilesHUD.get_children()
	var count2 = 1
	
	for i in range(Tileschildren.size()): #for Tiles
		if $ItemsHUD.get_child(i).get_script() == preload("res://hot_bar_item.gd"):  
			tileArray.append($TilesHUD.get_child(i))
			$TilesHUD.get_child(i).number.text = str(count2)
			count2 += 1
	
	
	var seedchildren = $SeedsHUD.get_children()
	var count3 = 1
	for i in range(seedchildren.size()): #for Tiles
		if $SeedsHUD.get_child(i).get_script() == preload("res://hot_bar_item.gd"):  
			seedArray.append($SeedsHUD.get_child(i))
			$SeedsHUD.get_child(i).number.text = str(count3)
			count3 += 1
	
	tileArray[0].setSelected(true)
	itemArray[0].setSelected(true)
	
	
	for i in range(player.items.size()): 
		itemArray[i].setTexture(player.items[i])
	for i in range(player.placeableTiles.size()): 
		tileArray[i].setTexture(player.placeableTiles[i])
	for i in range(player.seeds.size()): 
		seedArray[i].setTexture(player.seeds[i])
	tileArray[0].setSelected(true)
	itemArray[0].setSelected(true)
	
	
func updateSelectedTile(currentTile):
	if tileArray[currentTile].selected == false:
		for i in range(tileArray.size()):
			tileArray[i].setSelected(false)
	tileArray[currentTile].setSelected(true)
func updateSelectedItem(currentItem):
	if currentItem < 0 or currentItem >= itemArray.size():
		print("Invalid currentItem index:", currentItem)
		return
	if itemArray[currentItem].selected == false:
		for i in range(itemArray.size()):
			itemArray[i].setSelected(false)
	itemArray[currentItem].setSelected(true)
func updateSelectedSeed(number):
	if seedArray[number].selected == false:
		for i in range(seedArray.size()):
			seedArray[i].setSelected(false)
	seedArray[number].setSelected(true)
	
	itemArray[2].setTexture(player.seeds[number])

func setMode(type:String):
	if type == "farming":
		if mode == "nothing":
			$TilesHUD.visible = false
		$AnimationPlayer.play("FarmingMode")
		$ItemsHUD.visible = true
		#$TilesHUD.visible = true
		mode = "farming"
	if type == "placing":
		if mode == "nothing":
			$ItemsHUD.visible = false
		$AnimationPlayer.play("PlacingMode")
		#$ItemsHUD.visible = true
		$TilesHUD.visible = true
		mode = "placing"
	if type == "nothing":
		
		$AnimationPlayer.play("CursorMode")
		#$ItemsHUD.visible = false
		#$TilesHUD.visible = false
		var mode = "nothing"
	if type == "seed":
		$SeedsAnimationPlayer.play("Appear")
	if type == "noseed":
		$SeedsAnimationPlayer.play("Disappear")
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "PlacingMode":
		$ItemsHUD.visible = false
	if anim_name == "FarmingMode":
		$TilesHUD.visible = false
