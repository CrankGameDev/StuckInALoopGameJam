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
	
	print($Area2D/CollisionShape2D.shape.radius)
	var diff:float = ($Area2D/CollisionShape2D.shape.radius-size)/$Area2D/CollisionShape2D.shape.radius
	print(diff)
	var rev:float = 1-diff
	print(rev)
	
	$TextureRect.texture = $TextureRect.texture.duplicate()
	$TextureRect.texture.width =$Area2D/CollisionShape2D.shape.radius*2
	$TextureRect.texture.height =$Area2D/CollisionShape2D.shape.radius*2
	var grad = Gradient.new()
	grad.remove_point(1)
	grad.add_point(0,Color(1,0,0,1))
	grad.add_point(rev-0.01,Color(0,0,0,1))
	grad.add_point(rev+0.01,Color(0,0,0,0))
	grad.add_point(0.27,Color(0,0,0,0))
	grad.add_point(0.3,Color(1,1,1,1))
	grad.add_point(0.33,Color(0,0,0,0))
	grad.add_point(0.6,Color(1,1,1,0))
	grad.add_point(0.7,Color(1,0,0,0.5))
	grad.add_point(0.701,Color(1,0.18,0.18,0))
	#print(grad.get_point_count())
	$TextureRect.texture.gradient = grad
	#$TextureRect.position = Vector2($Area2D/CollisionShape2D.shape.radius,$Area2D/CollisionShape2D.shape.radius)
	$PlanetPanel.size = Vector2(size*2,size*2)
	$PlanetPanel.position = Vector2(-size,-size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
