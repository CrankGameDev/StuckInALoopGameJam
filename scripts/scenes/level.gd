## Represents a level in the game.
class_name Level
extends Node

## A signal emitted when the time limit of this level is elapsed.
signal timeout

@onready var player: CharacterBody2D = %Player
@onready var line:  Line2D = %Line
@onready var camera: Camera2D = %Camera

@onready var time_left_label: Label = %TimeLeftLabel

## The amount of time for the level to be completed in. [br]
## If the player persists in the level for longer than this amount of time
## then the [signal timeout] signal will be emitted.
@export_range(0.0, 600.0, 0.5, "or_greater", "suffix:seconds")
var time_limit: float = 300.0

@export var curve: Curve

var buf: float

## The amount of time left for level completion. [br]
## Returns [code]-1.0[/code] if the level is not yet ready.
var time_left: float :
	get: return _level_timer.time_left if _level_timer else -1.0

var _level_timer: Timer


func _ready() -> void:
	# Create an internal Timer node to track the level time.
	_level_timer = Timer.new()
	_level_timer.autostart = true
	_level_timer.one_shot = true
	_level_timer.wait_time = time_limit
	_level_timer.timeout.connect(self.timeout.emit)
	add_child(_level_timer, false, Node.INTERNAL_MODE_FRONT)


func _physics_process(delta: float) -> void:
	line.add_point(player.global_position)
	while line.get_point_count() > 1000:
		line.remove_point(0)
	camera.get_node(^"Label").text = "%1.3f" % player.DEBUG


func _process(delta: float) -> void:
	camera.global_position = player.global_position
	var zoomed = player.velocity.length()
	zoomed = remap(zoomed,150,30,0.5,1.5)
	#zoomed = clampf(zoomed,0.5,1.5)
	zoomed = curve.sample(zoomed)
	if buf != zoomed:
		print(zoomed)
	buf = zoomed
	#zoomed = maxf(zoomed,1)
	camera.zoom = Vector2(zoomed,zoomed)

	# Display time left in whole minutes and seconds.
	var minutes_left: int = floori(_level_timer.time_left / 60.0)
	var seconds_left: int = floori(_level_timer.time_left) % 60
	time_left_label.text = "{mins}:{secs}".format({
		"mins": minutes_left,
		"secs": "%02d" % seconds_left,
	})
