extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	$Line2D.add_point($CharacterBody2D.global_position)
	while $Line2D.get_point_count() > 1000:
		#print($Line2D.get_point_count())
		$Line2D.remove_point(0)
