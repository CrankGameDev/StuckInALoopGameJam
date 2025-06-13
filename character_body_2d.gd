extends CharacterBody2D

const SPEED = 30.0
const JUMP_VELOCITY = -20.0
var closestPlanet : Node
var x_vel : float = 0
var y_vel : float = 0

var DEBUG : float = 0

@onready var fuel_component: FuelComponent = $FuelComponent


func _ready() -> void:
	set_motion_mode(CharacterBody2D.MOTION_MODE_FLOATING)
	velocity.y = 110


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_wall():
		#velocity += get_gravity() * delta
		#print($Area2D.get_overlapping_areas())
		var a = $Area2D.get_overlapping_areas()
		var closeDist: float = 99999
		for i in a.size():
			#print(a[i])
			var pull = a[i].get_parent().pull
			var size = a[i].get_parent().size
			var gravity = a[i].get_parent().gravity
			var planetPos = a[i].global_position

			var b = global_position.distance_to(planetPos)
			if b < closeDist:
				closeDist = b
				closestPlanet = a[i].get_parent()
			#print(b)
			#print(b-a[i].get_parent().size)
			var c = global_position.direction_to(planetPos)
			#print(c)
			var d = size + (gravity*pull*200)
			#print(d-b)
			var e = (d-b)/pull
			DEBUG = e
			if e < 0:
				e = 0.1
			velocity += c*Vector2(e,e) * delta
			#print(c*Vector2(b-a[i].get_parent().size,b-a[i].get_parent().size))
			#print(c*Vector2(d-a[i].get_parent().size,d-a[i].get_parent().size))
	else:
		velocity = Vector2.ZERO

	#if closestPlanet != null:
		#rotation = global_position.angle_to_point(global_position.direction_to(closestPlanet.global_position))
	#print(rotation)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_wall():
		var a = global_position.direction_to(closestPlanet.global_position)
		velocity += a * Vector2(JUMP_VELOCITY,JUMP_VELOCITY)
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x := Input.get_axis("ui_left", "ui_right")
	if direction_x:
		x_vel = direction_x * SPEED
	else:
		x_vel = 0

	var direction_y := Input.get_axis("ui_up", "ui_down")
	if direction_y:
		y_vel = direction_y * SPEED
	else:
		y_vel = 0

	#var mouse = get_viewport().get_mouse_position()
	#var size:Vector2 = DisplayServer.screen_get_size()/2
	#var point = global_position.direction_to(mouse)
	#print(get_local_mouse_position())

	var point = get_local_mouse_position().normalized()

	#print(point)
	if Input.is_action_pressed("click") and fuel_component.amount > 0:
		velocity += 50*point*delta
		fuel_component.amount -= delta * 5.0
		$LineThrust.points[1] = -point*20
	else:
		$LineThrust.points[1] = Vector2.ZERO

	$LineVelocity.points[1] = velocity
	#$LineThrust.points[1] = point*20

	#velocity.x += x_vel
	velocity += Vector2(x_vel,y_vel)

	move_and_slide()

	#velocity.x -= x_vel
	velocity -= Vector2(x_vel,y_vel)
