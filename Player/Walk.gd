extends PlayerState

export (NodePath) var _animation_player

onready var animation_player: AnimationPlayer = get_node(_animation_player)

func enter(_msg := {}) -> void:
	animation_player.play("Walk")
	
	
func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	if Input.is_action_just_pressed("run"):
		player.move_speed = player.run_speed
	if Input.is_action_just_released("run"):
		player.move_speed = player.walk_speed 	
	
	if not is_zero_approx(player.get_input_direction()):
		player.velocity.x = lerp(player.velocity.x, player.get_input_direction() * player.move_speed, player.acceleration * delta)
	
	player.velocity.y += player.gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
	#if Input.is_action_just_pressed("run"):
	#		state_machine.transition_to("Run")
	elif is_zero_approx(player.get_input_direction()):
		state_machine.transition_to("Idle")
