extends Node
class_name  HotBar
@onready var player = find_parent("Player")

@onready var itemBar = $ItemsHUD
@onready var tileBar = $TilesHUD
@onready var seedBar = $SeedsHUD

var mode = "nothing"

func _ready() -> void:
	setTexture("items",2,"wheat")
	itemBar.updateAllItems(player.items)
	tileBar.updateAllItems(player.placeableTiles)
	seedBar.updateAllItems(player.harvestables)
	itemBar.updateAllAmounts(getAmountsFor(player.items))
	tileBar.updateAllAmounts(getAmountsFor(player.placeableTiles))
	seedBar.updateAllAmounts(getAmountsFor(player.harvestables))
	#tileBar.visible = false
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
		_:
			print("INVALID TYPE in function: updateAmounts")
func updateAll():
	itemBar.updateAllAmounts(getAmountsFor(player.items))
	tileBar.updateAllAmounts(getAmountsFor(player.placeableTiles))
	seedBar.updateAllAmounts(getAmountsFor(player.harvestables))
	

	
func updateSelected(type: String, index: int):
	match type:
		"items": itemBar.select(index)
		"tiles": tileBar.select(index)
		"seeds": seedBar.select(index)
		_:
			print("INVALID TYPE in function: updateSelected")
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
			$ItemsHUD/arrow.z_index = -1
		"noseed":
			$SeedsAnimationPlayer.play("Disappear")
		_:
			print("INVALID TYPE in function: setMode")
func setTexture(type:String, index: int, newTexture:String) -> void:
	match type:
		"items":itemBar.setSpecificTexture(index,newTexture)
		"tiles":tileBar.setSpecificTexture(index,newTexture)
		"seeds":seedBar.setSpecificTexture(index,newTexture)
		
		_:
			print("INVALID TYPE in function: setTexture")
	
func setAmount(type:String, index: int, newAmount:int) -> void:
	match type:
		"items":	
			itemBar.setSpecificAmount(index, newAmount)
		"tiles":	
			tileBar.setSpecificAmount(index, newAmount)
		"seeds":	
			seedBar.setSpecificAmount(index, newAmount)
			
		_:
			print("INVALID TYPE in function: setAmount")
	
func isSelected(type:String, index: int):
	match type:
		"items":	
			return itemBar.isSelected(index)
		"tiles":	
			return tileBar.isSelected(index)
		"seeds":	
			return seedBar.isSelected(index)
	
		_:
			print("INVALID TYPE in function: isSelected")
	
