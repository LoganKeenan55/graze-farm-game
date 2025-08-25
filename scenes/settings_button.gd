extends Node2D

@export var text := ""

var spriteOffset := Vector2(-1, 3)


func _ready() -> void:
	$Text.text = text

	if !getSettingState(text):
		$Sprite.position -= spriteOffset
	setOnOff(getSettingState(text))
	

func _on_button_pressed() -> void:
	setOnOff(!getSettingState(text))
	

func setOnOff(on: bool) -> void:
	#udate visuals
	$Sprite.frame = 0 if on else 1
	$Sprite.position = $Sprite.position - spriteOffset if on else $Sprite.position + spriteOffset

	ApplySetting(text, on)


func getSettingState(setting: String) -> bool:
	match setting:
		"Fullscreen":
			return DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
		"Autosave":
			return GlobalVars.autoSave
		"Cheats":
			return GlobalVars.cheats
		_:
			return false


func ApplySetting(setting: String, value: bool) -> void:
	match setting:
		"Fullscreen":
			if value:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		"Autosave":
			GlobalVars.autoSave = value
		"Cheats":
			GlobalVars.cheats = value
