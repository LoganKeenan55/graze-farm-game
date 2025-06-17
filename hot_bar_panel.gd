extends Node

@export var hotBarType:String #"items", "tiles", "seeds"

var items:Array[Node] = []

func _ready() -> void:
	setArr()
	
func setArr():
	var count = 1
	for child in get_children():
		if child.get_script() == preload("res://hot_bar_item.gd"):  
			items.append(child)
			child.indice.text = str(count)
			child.setSelected(false)

			count += 1
	
	if items.size() > 0:
		items[0].setSelected(true)

func setAllSeedsTexture(newTexture:String) -> void:
	for item in items:
		item.setTexture(newTexture)

func updateAllItems(playerData: Array):
	for i in range(min(items.size(), playerData.size())): #Size of array to player
		items[i].setTexture(playerData[i])

func updateAllAmounts(amounts: Array):
	if hotBarType == "tiles":
		for i in range(min(items.size(), amounts.size())):
			items[i].setAmount(amounts[i])
	else:
		for i in range(min(items.size(), amounts.size())):
			items[i].setAmount(-1)
			

func setSpecificTexture(index:int, newTexture:String):
	items[index].setTexture(newTexture)
	
func setSpecificAmount(index:int, newAmount:int):
	items[index].setAmount(newAmount)

func select(index: int):
	if index < 0 or index >= items.size():
		print("Invalid index for", hotBarType)
		return

	for i in range(items.size()):
		items[i].setSelected(i == index)
	#print("at " + str(index) + " "+ str(items[index].selected))
	

func isSelected(index: int) -> bool:
	#print("at " + str(index) + " "+ str(items[index].selected))
	return items[index].selected
	
