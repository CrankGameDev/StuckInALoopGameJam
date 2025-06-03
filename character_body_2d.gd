extends CharacterBody2D


const SPEED = 30.0
const JUMP_VELOCITY = -20.0
var closestPlanet : Node
var x_vel : float = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		#velocity += get_gravity() * delta
		#print($Area2D.get_overlapping_areas())
		var a = $Area2D.get_overlapping_areas()
		var closeDist: float = 99999
		for i in a.size():
			#print(a[i])
			var b = global_position.distance_to(a[i].global_position)
			if b < closeDist:
				closeDist = b
				closestPlanet = a[i].get_parent()
			print(b)
			print(b-a[i].get_parent().size)
			var c = global_position.direction_to(a[i].global_position)
			print(c)
			velocity += c*Vector2(b-a[i].get_parent().size,b-a[i].get_parent().size) * delta
			print(c*Vector2(b-a[i].get_parent().size,b-a[i].get_parent().size))
	else:
		velocity = Vector2.ZERO

	if closestPlanet != null:
		rotation = global_position.angle_to_point(global_position.direction_to(closestPlanet.global_position))
	#print(rotation)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		var a = global_position.direction_to(closestPlanet.global_position)
		velocity += a * Vector2(JUMP_VELOCITY,JUMP_VELOCITY)
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		x_vel = direction * SPEED
	else:
		x_vel = 0
	
	velocity.x += x_vel

	move_and_slide()
	
	velocity.x -= x_vel
