class_name Level
extends Node

@onready var player: CharacterBody2D = %Player
@onready var line:  Line2D = %Line
@onready var camera: Camera2D = %Camera

@export var curve: Curve
var buf: float


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
