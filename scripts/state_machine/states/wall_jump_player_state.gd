extends State

@export
var fall_state: State
@export
var idle_state: State
@export
var run_state: State
@export
var wall_slide_state: State

@export
var jump_speed: float = 5.0
@export
var jump_velocity: float = 5.0
@export
var jump_peak_time: float = 0.45
@export
var jump_height: float = 3.75
@export
var jump_distance: float = 6.75
@export
var wall_jump_boost: float = 20.0
@export
var wall_jump_boost_duration: float = 0.2

var wall_normal = Vector3();
var is_boosting: bool = false
var boost_time: float = 0.0

@onready 
var head: Node3D = $"../../Head"
@onready 
var player: Node3D = $"../../Visuals"
@onready 
var left_ray_cast: RayCast3D = $"../../LeftRayCast"
@onready 
var right_ray_cast: RayCast3D = $"../../RightRayCast"


func calculate_jump_parameters() -> void:
	jump_gravity = (2 * jump_height) / pow(jump_peak_time, 2)
	jump_velocity = jump_gravity * jump_peak_time

func enter() -> void:
	pass

func _ready() -> void:
	calculate_jump_parameters()

func process_physics(delta: float) -> State:
	if is_boosting:
		apply_wall_jump_boost(delta)
		
	if Input.is_action_just_pressed("jump") && parent.is_on_wall_only():
		parent.velocity.y = jump_velocity
		is_boosting = true
		boost_time = 0.0
		
		if left_ray_cast.is_colliding():
			wall_normal = left_ray_cast.get_collision_normal()
			#parent.velocity += wall_normal * wall_jump_boost
			#print("left: (", wall_normal.x, ", ", wall_normal.y, ", ", wall_normal.z, ")\n")
		elif right_ray_cast.is_colliding():
			wall_normal = right_ray_cast.get_collision_normal()
			#parent.velocity += wall_normal * wall_jump_boost
			#print("rigt: (", wall_normal.x, ", ", wall_normal.y, ", ", wall_normal.z, ")\n")
		#parent.move_and_slide()
	
	# falling
	if parent.velocity.y < 0:
		if parent.is_on_wall_only():
			return process_state_change(wall_slide_state)
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

func apply_wall_jump_boost(delta: float) -> void:
	# Gradually apply the boost over time
	wall_normal.y = 0
	wall_normal.x = 0
	if boost_time < wall_jump_boost_duration:
		var boost_factor = boost_time / wall_jump_boost_duration
		parent.velocity += lerp(Vector3(0,0,parent.velocity.z), wall_normal * wall_jump_boost, boost_factor) * delta
		boost_time += delta
		parent.move_and_slide()
	else:
		# Stop boosting once the duration is complete
		is_boosting = false
