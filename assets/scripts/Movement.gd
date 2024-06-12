extends Sprite2D

var speed = 400
var turn_speed = PI/5
var angular_speed = PI
var travel_distance = 0
@onready var thrusters = get_node("ForwardsThrust")
var desired_rotation = rotation

signal reached_waypoint()

func _process(delta):
	
	var velocity = Vector2.ZERO
	
	if !abs(rotation - desired_rotation) < 0.0001:
		rotation_cycle_reset()
		if rotation > desired_rotation:
			rotation -= turn_speed * delta
		else:
			rotation += turn_speed * delta 
			
		if (abs(rotation - desired_rotation) < turn_speed * delta):
			rotation = desired_rotation
	#elif travel_distance > 0:
		#velocity = Vector2.UP.rotated(rotation) * speed
		#travel_distance -= speed * delta
		#thrusters.visible = true
		#if travel_distance <= 0:
			#reached_waypoint.emit()
			#thrusters.visible = false
	position += velocity * delta	

func rotation_cycle_reset():
	if rotation > PI:
		rotation -= 2 * PI
		desired_rotation -= 2 * PI
	elif rotation < PI:
		rotation += 2 * PI
		desired_rotation += 2 * PI


func _on_waypoints_new_waypoint(waypoint_position):
	desired_rotation = position.angle_to_point(waypoint_position)
	desired_rotation = find_shortest_rotation_path(rotation, desired_rotation)
	desired_rotation += PI/2
	travel_distance = position.distance_to(waypoint_position)
	print(rotation != desired_rotation, rotation,  " ", desired_rotation)

func find_shortest_rotation_path(origin, destination):
	if origin > 0 && destination > 0:
		return destination
	elif origin < 0 && destination < 0:
		return destination
	elif origin < PI/2 && origin > -PI/2 && destination < PI/2 && destination > -PI/2:
		return destination
	elif origin > PI/4 && destination < -PI/4:
		return destination + 2 * PI
	elif origin < -PI/4 && destination > PI/4:
		print("hi")
		return destination - (2 * PI) 
	else:
		print(origin, " ", destination)
		return destination
