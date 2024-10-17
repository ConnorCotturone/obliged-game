extends State

@export
var idle_state: State
@export
var run_state: State

@onready var head: Node3D = $"../../Head"
@onready var player: Node3D = $"../../Visuals"

func process_physics(delta: float) -> State:
	if parent.velocity.y > terminal_velocity:
		#print("Fall Vel=", parent.velocity.y)
		parent.velocity += Vector3(0.0, -fall_gravity, 0.0) * delta
	
	if parent.velocity.y < terminal_velocity:
		parent.velocity.y = terminal_velocity
	
	var input_direction = Input.get_axis('left', 'right') 
	
	if input_direction == -1:
		player.rotation = Vector3(0, PI, 0)
	elif input_direction == 1:
		player.rotation = Vector3(0, 0, 0)
	parent.move_and_slide()
	
	var direction = (head.transform.basis * Vector3(0, 0, input_direction))
	if direction:
		parent.velocity.z = direction.z * run_speed
	else:
		parent.velocity.z = 0.0
	
	if parent.is_on_floor():
		if input_direction != 0:
			return process_state_change(run_state)
		return process_state_change(idle_state)
	#if parent.is_on_wall_only()&& !Input.is_action_just_pressed("left") && !Input.is_action_just_pressed("right"):
	#	return process_state_change(wall_slide_state)
	return null
