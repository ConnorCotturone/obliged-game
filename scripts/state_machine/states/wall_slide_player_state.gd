extends State

@export
var idle_state: State
@export
var fall_state: State
@export
var wall_jump_state: State

@onready 
var head: Node3D = $"../../Head"
@onready 
var player: Node3D = $"../../Visuals"
@onready 
var left_ray_cast: RayCast3D = $"../../LeftRayCast"
@onready 
var right_ray_cast: RayCast3D = $"../../RightRayCast"

func process_input(event: InputEvent):
	if Input.is_action_pressed('left') && !left_ray_cast.is_colliding():
		player.rotation = Vector3(0, PI, 0)
		return process_state_change(fall_state)
	if Input.is_action_pressed("right") && !right_ray_cast.is_colliding():
		player.rotation = Vector3(0, 0, 0)
		return process_state_change(fall_state)
	if Input.is_action_just_pressed("jump"):
		return process_state_change(wall_jump_state)

func process_physics(delta: float) -> State:
	if parent.is_on_floor():
		return process_state_change(idle_state)	
	else:
		if parent.velocity.y > wall_slide_terminal_velocity:
			parent.velocity += Vector3(0.0, -wall_slide_gravity, 0.0) * delta
			print(">, ", parent.velocity.y)
		else:
			parent.velocity.y = wall_slide_terminal_velocity;
			print(">' ", parent.velocity.y)
			
	parent.move_and_slide()
	if !parent.is_on_wall_only():
		parent.rotation = Vector3(0,0,0)
		return process_state_change(fall_state)
	return null
