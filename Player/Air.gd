extends PlayerState

export (NodePath) var _animation_player
onready var animation_player: AnimationPlayer = get_node(_animation_player)

func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		jump()
	elif msg.has("no_coyote"):
		return
	else:
		player.CoyoteTimer.start()
	

func physics_update(delta: float) -> void:
	
	if Input.is_action_just_pressed("run"):
		player.move_speed = player.run_speed
	if Input.is_action_just_released("run"):
		player.move_speed = player.walk_speed 	
	
	if not is_zero_approx(player.get_input_direction()):
		player.velocity.x = lerp(player.velocity.x, player.get_input_direction() * player.move_speed, player.acceleration * delta)
	else:
		player.velocity.x = lerp(player.velocity.x, 0, player.air_friction* delta)

	player.velocity.y += player.gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	if Input.is_action_just_pressed("jump") && player.jumps_available > 0:
		jump()

	if player.is_on_floor():
		player.jumps_available = 2
		if is_zero_approx(player.get_input_direction()):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")

func jump():
	player.jumps_available -= 1
	player.velocity.y = -player.jump_impulse
	animation_player.play("Jump")


func _on_CoyoteTimer_timeout():
	if not player.is_on_floor():
		player.jumps_available = 1
