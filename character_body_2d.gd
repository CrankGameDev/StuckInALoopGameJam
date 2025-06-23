extends CharacterBody2D

const SPEED = 30.0
const JUMP_VELOCITY = -20.0
var closestPlanet : Node
var x_vel : float = 0
var y_vel : float = 0

var simLength : float = 0

var DEBUG : float = 0

@onready var fuel_component: FuelComponent = $FuelComponent


func _ready() -> void:
	set_motion_mode(CharacterBody2D.MOTION_MODE_FLOATING)
	velocity.y = 110


func _physics_process(delta: float) -> void:
	if !Global.pause:
		# Add the gravity.
		if not is_on_wall():
			#velocity += get_gravity() * delta
			#print($Area2D.get_overlapping_areas())
			var a = $Area2D.get_overlapping_areas()
			var closeDist: float = 99999
			#simulate_gravity(a)
			for i in a.size():
				#print(a[i])
				var result = simulate_gravity(a[i],global_position)
				velocity += result*delta
				#var pull = a[i].get_parent().pull
				#var size = a[i].get_parent().size
				#var gravity = a[i].get_parent().gravity
				#var planetPos = a[i].global_position
	#
				#var b = global_position.distance_to(planetPos)
				#if b < closeDist:
					#closeDist = b
					#closestPlanet = a[i].get_parent()
				##print(b)
				##print(b-a[i].get_parent().size)
				#var c = global_position.direction_to(planetPos)
				##print(c)
				#var d = size + (gravity*pull*200)
				##print(d-b)
				#var e = (d-b)/pull
				#DEBUG = e
				#if e < 0:
					#e = 0.1
				#velocity += c*Vector2(e,e) * delta
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
		
		$Line2D2.clear_points()
		$Line2D2.add_point(Vector2.ZERO)
		simLength = 0
		
		var space_rid = get_world_2d().space
		var space_state = PhysicsServer2D.space_get_direct_state(space_rid)
		
		var query = PhysicsPointQueryParameters2D.new()
		query.collide_with_areas = true
		query.collide_with_bodies = false
		query.set_collision_mask(1)
		
		query.position = position + (velocity*delta)
		#print(position)
		#print(query.position)
		var result = space_state.intersect_point(query)
		#print(result)
		var simuVol = velocity
		var o = 200
		while simLength < 500:
			var offset = Vector2.ZERO
			for i in result.size():
				var test = simulate_gravity(result[i]["collider"],query.position)
				#print(query.position)
				#velocity += test*delta
				offset += test
				#print(query.position)
				#print(test*delta)
				#print(position)
				#print(query.position)
			#print(query.position)
			simuVol += offset*delta
			query.position += simuVol*delta
			#print(query.position)
			#print("--")
			#print(query.position)
			#print(position)
			result = space_state.intersect_point(query)
			#print(result)
			$Line2D2.add_point(query.position-position)
			simLength += $Line2D2.get_point_position($Line2D2.get_point_count()-1).distance_to($Line2D2.get_point_position($Line2D2.get_point_count()-2))
			
			o-=1


func simulate_gravity(input,pointPos):
	var pull = input.get_parent().pull
	var size = input.get_parent().size
	var gravity = input.get_parent().gravity
	var planetPos = input.global_position

	var dist = pointPos.distance_to(planetPos)
	#print(b)
	#print(b-a[i].get_parent().size)
	var direct = pointPos.direction_to(planetPos)
	#print(c)
	var pullCalc = size + (gravity*pull*200)
	#print(d-b)
	var final = (pullCalc-dist)/pull
	DEBUG = final
	if final < 0:
		final = 0.1
	return direct*Vector2(final,final)
