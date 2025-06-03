extends StaticBody2D

@export var size: float = 10
@export var gravity: float = 1
@export var pull: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.shape.radius = size
	#$Panel.size = Vector2(size,size)
	$Area2D/CollisionShape2D.shape.radius = size + (pull*size*5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
