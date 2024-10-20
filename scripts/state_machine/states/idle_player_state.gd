extends State

@export
var ground_jump_state: State
@export
var run_state: State
@export
var fall_state: State

var current_speed: float = 0.0
var acceleration: float = 18

@onready 
var head: Node3D = $"../../Head"

func enter() -> void:
	current_speed = parent.velocity.z
	#parent.velocity.z = 0

func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed('jump') and parent.is_on_floor():
		return process_state_change(ground_jump_state)
	if (Input.is_action_pressed('left') or Input.is_action_pressed('right')) and !Input.is_action_pressed("sprint"):
		return process_state_change(run_state)
	return null

func process_physics(delta: float) -> State:
	#parent.velocity += Vector3(0.0, -fall_gravity, 0.0) * delta
	#parent.move_and_slide()
	
	# should be properly oriented already
	#if input_direction == -1:
	#	player.rotation = Vector3(0, PI, 0)
	#elif input_direction == 1:
	#	player.rotation = Vector3(0, 0, 0)

	if current_speed > 0.0:
		current_speed = max(current_speed - acceleration * delta, 0.0)
	elif current_speed < 0.0:
		current_speed = min(current_speed + acceleration * delta, 0.0)	
	
	parent.velocity.z = current_speed

	parent.move_and_slide()
	if !parent.is_on_floor():
		return process_state_change(fall_state)
	return null
