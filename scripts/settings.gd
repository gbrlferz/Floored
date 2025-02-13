extends VBoxContainer

@export var fullscreen_checkbox: CheckBox
var config_path := "user://settings.cfg"

func _ready() -> void:
	# Load settings from the config file
	var config = ConfigFile.new()
	var err = config.load(config_path)
	var fullscreen = false
	if err == OK:
		# Try to get the saved fullscreen value (default to false if not found)
		fullscreen = config.get_value("display", "fullscreen", false)
	else:
		# File doesn't exist or couldn't be loaded; use default value
		fullscreen = false
	
	# Set the checkbox and window mode based on the loaded setting
	fullscreen_checkbox.button_pressed = fullscreen
	var new_mode = fullscreen if DisplayServer.WINDOW_MODE_FULLSCREEN else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(new_mode)
	
	# Connect the checkbox's toggled signal to the handler
	fullscreen_checkbox.toggled.connect(_on_fullscreen_toggled)


func _on_fullscreen_toggled(button_pressed: bool):
	# Set the window mode based on the checkbox state
	var new_mode = DisplayServer.WINDOW_MODE_FULLSCREEN if button_pressed else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(new_mode)

	# Save the new setting to the config file
	var config = ConfigFile.new()
	config.set_value("display", "fullscreen", button_pressed)
	var err = config.save(config_path)
	if err != OK:
		print("Error saving settings!")

	# If the mode change fails, revert the checkbox state
	if DisplayServer.window_get_mode() != new_mode:
		fullscreen_checkbox.button_pressed = !button_pressed
		print("Failed to change window mode")
