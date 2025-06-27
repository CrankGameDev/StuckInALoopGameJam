@tool
extends StaticBody2D

@export var size: float = 10:
	set(value):
		size = value
		_should_update = true
		_update.call_deferred()

@export var gravity: float = 1:
	set(value):
		gravity = value
		_should_update = true
		_update.call_deferred()

@export var pull: float = 1:
	set(value):
		pull = value
		_should_update = true
		_update.call_deferred()


# Signifies whether an update is necessary.
# Deferred calls run at the end of the current frame,
# which means if multiple properties are changed in one frame we can ensure
# that the full update function only runs once by limiting it to when `_should_update` is true.
var _should_update: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_should_update = true
	_update()


func _update() -> void:
	# Ensure only one update happens per frame.
	if not _should_update:
		return
	_should_update = false

	# Resources are duplicated automatically for each planet using `local_to_scene`

	$CollisionShape2D.shape.radius = size
	#$Panel.size = Vector2(size,size)
	$Area2D/CollisionShape2D.shape.radius = size + (pull * 200)

	print($Area2D/CollisionShape2D.shape.radius)
	var diff: float = ($Area2D/CollisionShape2D.shape.radius - size) / $Area2D/CollisionShape2D.shape.radius
	print(diff)
	var rev: float = 1 - diff
	print(rev)

	$TextureRect.texture.width = $Area2D/CollisionShape2D.shape.radius * 2
	$TextureRect.texture.height = $Area2D/CollisionShape2D.shape.radius * 2

	var grad = Gradient.new()
	grad.remove_point(1)
	grad.add_point(0, Color(1, 0, 0, 1))
	grad.add_point(rev - 0.01, Color(0, 0, 0, 1))
	grad.add_point(rev + 0.01, Color(0, 0, 0, 0))
	grad.add_point(0.27, Color(0, 0, 0, 0))
	grad.add_point(0.3, Color(1, 1, 1, 1))
	grad.add_point(0.33, Color(0, 0, 0, 0))
	grad.add_point(0.6, Color(1, 1, 1, 0))
	grad.add_point(0.7, Color(1, 0, 0, 0.5))
	grad.add_point(0.701, Color(1, 0.18, 0.18, 0))
	#print(grad.get_point_count())
	$TextureRect.texture.gradient = grad

	#$TextureRect.position = Vector2($Area2D/CollisionShape2D.shape.radius,$Area2D/CollisionShape2D.shape.radius)
	$PlanetPanel.size = Vector2(size * 2, size * 2)
	$PlanetPanel.position = Vector2(-size, -size)
