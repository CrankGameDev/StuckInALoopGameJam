## A global node which tracks level scenes and their ordering.
extends Node

## An array of level scenes in order. [br]
## Please ensure that scenes extend [code]"res://scenes/base_level.tscn"[/code]
## to maintain proper functionality.
@export_file("*.tscn") var levels: Array[String]


func _ready() -> void:
	if OS.is_debug_build():
		# Use a dictionary as a set to identify duplicate levels.
		# Duplicate levels will cause infinite loops in
		var level_set: Dictionary
		for level in levels:
			if level_set.has(level):
				push_error(
					"Duplicate level: \"%s\" in LevelManager.levels" % level
					+ "\nThis will cause infinite looping. Please ensure only one instance of each level scene is set in the array."
				)
			if not ResourceLoader.exists(level, "PackedScene"):
				push_error("Could not find a PackedScene at level path \"%s\"" % level)
			level_set[level] = true


## Gets the level number (starting at [code]1[/code]) of the given [param level_path]. [br]
## Returns [code]0[/code] if the given level scene path was not registered.
func get_level_number(level_path: String) -> int:
	# `find` will search for the index the level appears at.
	#  It will return `-1` if the level could not be found.
	var idx: int = levels.find(level_path)
	return idx + 1


## Gets the level scene path for the given level number. [br]
## Returns an empty path if no level exists at the given number.
func get_level_path(level_number: int) -> String:
	var idx: int = level_number - 1
	if idx < 0 or idx >= levels.size():
		return ""
	return levels[idx]


## Gets the [String] path to the next level scene after the given [param current_level]. [br]
## This function will error if [param current_level] does not come from a scene file. [br]
## Returns an empty string if the [param current_level] is not registered
## or if a subsequent level could not be found.
func get_next_level_path(current_level: Level) -> String:
	var level_number: int = get_level_number(current_level.scene_file_path)
	return get_level_path(level_number + 1)


## Returns whether the given [param level] is registered to the level manager.
func is_registered(level: Level) -> bool:
	var path: String = level.scene_file_path
	return path and levels.has(path)
