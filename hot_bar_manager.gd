extends Node

@onready var player = find_parent("Player")

@onready var itemBar = $ItemsHUD
@onready var tileBar = $TilesHUD
@onready var seedBar = $SeedsHUD

var mode = "nothing"

func _ready() -> void:
	itemBar.updateAllItems(player.items)
	tileBar.updateAllItems(player.placeableTiles)
	seedBar.updateAllItems(player.harvestables)
	itemBar.updateAllAmounts(getAmountsFor(player.items))
	tileBar.updateAllAmounts(getAmountsFor(player.placeableTiles))
	seedBar.updateAllAmounts(getAmountsFor(player.harvestables))
	
func getAmountsFor(list: Array) -> Array:
	var result = []
	for name in list:
		result.append(player.inventory.get(name, 0))
	return result


func setPlayerData(items, tiles, harvestables):
	itemBar.updateAllItems(items)
	tileBar.updateAllItems(tiles)
	seedBar.updateAllItems(harvestables)

func updateAmounts(type: String):
	match type:
		"items":
			itemBar.updateAllAmounts(getAmountsFor(player.items))
		"tiles":
			tileBar.updateAllAmounts(getAmountsFor(player.placeableTiles))
		"seeds":
			seedBar.updateAllAmounts(getAmountsFor(player.harvestables))

func updateSelected(type: String, index: int):
	match type:
		"items": itemBar.select(index)
		"tiles": tileBar.select(index)
		"seeds": seedBar.select(index)
	
func setMode(type: String):
	match type:
		"farming":
			$AnimationPlayer.play("FarmingMode")
			$ItemsHUD.visible = true
			mode = "farming"
		"placing":
			$AnimationPlayer.play("PlacingMode")
			$TilesHUD.visible = true
			mode = "placing"
		"nothing":
			$AnimationPlayer.play("CursorMode")
			mode = "nothing"
		"seed":
			$SeedsAnimationPlayer.play("Appear")
		"noseed":
			$SeedsAnimationPlayer.play("Disappear")

func setTexture(type:String, index: int, newTexture:String) -> void:
	match type:
		"items":	
			itemBar.setSpecificTexture(index,newTexture)
		"tiles":	
			tileBar.setSpecificTexture(index,newTexture)
		"seeds":	
			seedBar.setSpecificTexture(index,newTexture)
func setAmount(type:String, index: int, newAmount:int) -> void:
	match type:
		"items":	
			itemBar.setSpecificAmount(index, newAmount)
		"tiles":	
			tileBar.setSpecificAmount(index, newAmount)
		"seeds":	
			seedBar.setSpecificAmount(index, newAmount)

func isSelected(type:String, index: int) -> bool:
	
	match type:
		"items":	
			return itemBar.isSelected(index)
		"tiles":	
			return tileBar.isSelected(index)
		"seeds":	
			
			return seedBar.isSelected(index)
	
	print("INVALID TYPE")
	return false
