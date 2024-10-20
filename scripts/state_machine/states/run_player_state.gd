extends State

@export
var idle_state: State
@export
var fall_state: State
@export
var ground_jump_state: State

var current_speed: float = 0.0
var acceleration: float = 12

@onready 
var head: Node3D = $"../../Head"

@onready 
var player: Node3D = $"../../Visuals"

func process_input(event: InputEvent) -> State:	
	if Input.is_action_pressed('jump') and parent.is_on_floor():
		return process_state_change(ground_jump_state)
	return null

func enter() -> void:
	current_speed = abs(parent.velocity.z)

func process_physics(delta: float) -> State:
	var input_direction = Input.get_axis('left', 'right') 
	
	if input_direction == 0:
		return process_state_change(idle_state)
	elif input_direction == -1:
		player.rotation = Vector3(0, PI, 0)
	elif input_direction == 1:
		player.rotation = Vector3(0, 0, 0)
		
	if current_speed < run_speed:
		current_speed = min(current_speed + acceleration * delta, run_speed)

	var direction = (head.transform.basis * Vector3(0, 0, input_direction))
	if direction:
		parent.velocity.z = direction.z * current_speed
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return process_state_change(fall_state)
	return null
