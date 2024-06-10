extends Node2D

var waypoint_scene = load("res://game-objects/waypoint.tscn")

signal new_waypoint(waypoint_position)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.shift_pressed:
				spawn_waypoint(get_global_mouse_position(), true)
			else:
				spawn_waypoint(get_global_mouse_position(), false)
				

func spawn(spawn_global_position, scene, is_shift):
	if !is_shift:
		for child in get_children():
			child.queue_free()
	var instance = waypoint_scene.instantiate()
	instance.global_position=spawn_global_position
	add_child(instance)	

func spawn_waypoint(spawn_global_position, is_shift):
	spawn(spawn_global_position, waypoint_scene, is_shift)
	if !is_shift:
		new_waypoint.emit(spawn_global_position)

func _on_ship_reached_waypoint():
	print(get_children(), get_child_count())
	if get_child_count() >= 1:
		get_child(0).queue_free();
	if get_child_count() >= 2:
		new_waypoint.emit(get_child(1).global_position);
