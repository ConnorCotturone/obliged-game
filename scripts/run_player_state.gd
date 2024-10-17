extends State

@export
var idle_state: State
@export
var fall_state: State

@onready 
var head: Node3D = $"../../Head"

@onready 
var player: Node3D = $"../../Visuals"

func process_input(event: InputEvent) -> State:	
	return null

func process_physics(delta: float) -> State:
	var input_direction = Input.get_axis('left', 'right') 
	
	if input_direction == 0:
		return process_state_change(idle_state)
	elif input_direction == -1:
		player.rotation = Vector3(0, PI, 0)
	elif input_direction == 1:
		player.rotation = Vector3(0, 0, 0)

	var direction = (head.transform.basis * Vector3(0, 0, input_direction))
	if direction:
		parent.velocity.z = direction.z * run_speed
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return process_state_change(fall_state)
	return null
