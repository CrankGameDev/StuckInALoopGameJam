extends StaticBody2D

@export var size: float = 10
@export var gravity: float = 1
@export var pull: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = size
	#$Panel.size = Vector2(size,size)
	$Area2D/CollisionShape2D.shape = $Area2D/CollisionShape2D.shape.duplicate()
	$Area2D/CollisionShape2D.shape.radius = size + (pull*size*5)
	$TextureRect.size = Vector2($Area2D/CollisionShape2D.shape.radius*2,$Area2D/CollisionShape2D.shape.radius*2)
	$TextureRect.position = Vector2(-$Area2D/CollisionShape2D.shape.radius,-$Area2D/CollisionShape2D.shape.radius)
	$PlanetPanel.size = Vector2(size*2,size*2)
	$PlanetPanel.position = Vector2(-size,-size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
