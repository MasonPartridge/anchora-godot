extends Sprite2D

var speed = 400
var angular_speed = PI
var travel_distance = 0;

signal reached_waypoint()

func _process(delta):
	
	var velocity = Vector2.ZERO
	
	if travel_distance > 0:
		velocity = Vector2.UP.rotated(rotation) * speed
		travel_distance -= speed * delta
		if travel_distance <= 0:
			reached_waypoint.emit()
	position += velocity * delta

func _on_waypoints_new_waypoint(waypoint_position):
	rotation = waypoint_position.angle_to_point(position) - PI/2
	travel_distance = position.distance_to(waypoint_position)
