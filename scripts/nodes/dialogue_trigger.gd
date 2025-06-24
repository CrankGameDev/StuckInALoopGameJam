class_name DialogueTrigger
extends Area2D


@export var timeline: DialogicTimeline
@export var one_shot: bool = true
@export var pause_level: bool = true


func _init() -> void:
	body_entered.connect(_on_player_entered, CONNECT_ONE_SHOT)


func _on_player_entered(body: Node2D) -> void:
	if one_shot:
		if has_meta(&"_dialogue_triggered"):
			return
		else:
			set_meta(&"_dialogue_triggered", true)
	if pause_level:
		# TODO: We could use Global.pause here, but that'd require handling it in the pause menu.
		await get_tree().process_frame
		var level: Node = get_tree().current_scene
		level.process_mode = Node.PROCESS_MODE_DISABLED
		Dialogic.start(timeline)
		await Dialogic.timeline_ended
		level.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		Dialogic.start(timeline)
