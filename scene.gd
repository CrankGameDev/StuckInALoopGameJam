extends Node2D


@export var curve: Curve
var buf: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	$Line2D.add_point($CharacterBody2D.global_position)
	while $Line2D.get_point_count() > 1000:
		#print($Line2D.get_point_count())
		$Line2D.remove_point(0)
	$Camera2D/Label.text = str($CharacterBody2D.DEBUG)


func _process(delta: float) -> void:
	$Camera2D.global_position = $CharacterBody2D.global_position
	var zoomed = $CharacterBody2D.velocity.length()
	zoomed = remap(zoomed,150,30,0.5,1.5)
	#zoomed = clampf(zoomed,0.5,1.5)
	zoomed = curve.sample(zoomed)
	if buf != zoomed:
		print(zoomed)
	buf = zoomed
	
	#zoomed = maxf(zoomed,1)
	$Camera2D.zoom = Vector2(zoomed,zoomed)
	
	if Global.pause:
		$Camera2D/Panel.visible = true
	else:
		$Camera2D/Panel.visible = false
		$Camera2D/Panel.scale = Vector2(1,1)/$Camera2D.zoom


func _on_button_pressed() -> void:
	Global.pause = false
