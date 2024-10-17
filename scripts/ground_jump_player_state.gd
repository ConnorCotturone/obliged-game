extends State

@export
var fall_state: State
@export
var idle_state: State
@export
var run_state: State

@export
var jump_speed: float = 5.0
@export
var jump_velocity: float = 5.0
@export
var jump_peak_time: float = 0.45
#@export
#var jump_fall_time: float = 0.5
@export
var jump_height: float = 3.75
@export
var jump_distance: float = 6.75


@onready 
var head: Node3D = $"../../Head"
@onready 
var player: Node3D = $"../../Visuals"

func calculate_jump_parameters() -> void:
	jump_gravity = (2 * jump_height) / pow(jump_peak_time, 2)
	fall_gravity = (2 * jump_height) / pow(jump_peak_time, 2)	
	jump_velocity = jump_gravity * jump_peak_time

func enter() -> void:
	#super()
	#parent.velocity.y = -jump_force
	pass

func _ready() -> void:
	calculate_jump_parameters()

func process_physics(delta: float) -> State:
	#print("Jump Vel=",parent.velocity.y)
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		parent.velocity.y = jump_velocity
	
	if parent.velocity.y < 0:
		return process_state_change(fall_state)
	
	var input_direction = Input.get_axis('left', 'right') 
	
	if input_direction == -1:
		player.rotation = Vector3(0, PI, 0)
	elif input_direction == 1:
		player.rotation = Vector3(0, 0, 0)
		
	var direction = (head.transform.basis * Vector3(0, 0, input_direction))
	parent.velocity.y -= jump_gravity * delta
	#if input_direction == 0:
		# prob broken since you want the entire jump animation to play regardless
		#return fall_state
	#else:
	parent.velocity.z = direction.z * run_speed
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if input_direction != 0:
			return process_state_change(run_state)
		if !Input.is_action_just_pressed("jump"):
			return process_state_change(idle_state)
	
	return null
