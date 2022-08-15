class_name Player
extends KinematicBody2D

var walk_speed = 80
var run_speed = 120
var move_speed = walk_speed
var jump_impulse = 360
var gravity = 1200
var acceleration = 60
var friction = 20
var air_friction = 10
var jumps_available = 2
onready var CoyoteTimer = $CoyoteTimer

var velocity := Vector2.ZERO

func get_input_direction() -> float:
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if direction < 0:
		$Sprite.flip_h = true
	if direction > 0:
		$Sprite.flip_h = false
	
	return direction
