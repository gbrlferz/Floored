extends Control

@export var world_scene: PackedScene

@export_group("Buttons")
@export var play_button: Button
@export var focus_settings_button: Control

# Main Menu
@onready var menu_buttons := $MenuButtons
@onready var settings_button := $MenuButtons/SettingsButton

# Settings Menu
@onready var settings := $SettingsMenu

func _ready() -> void:
	menu_buttons.visible = true
	settings.visible = false
	play_button.grab_focus()

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(world_scene)


func _on_options_button_pressed() -> void:
	menu_buttons.visible = false
	settings.visible = true
	focus_settings_button.grab_focus()


func _on_back_button_pressed() -> void:
	menu_buttons.visible = true
	settings.visible = false
	settings_button.grab_focus()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
