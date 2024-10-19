extends State

@export
var idle_state: State
@export
var fall_state: State

@onready var head: Node3D = $"../../Head"
@onready var player: Node3D = $"../../Visuals"

func process_physics(delta: float) -> State:
	if parent.is_on_floor():
		return process_state_change(idle_state)
	
	if parent.velocity.y > wall_slide_terminal_velocity:
		print(">, ", parent.velocity.y)
		parent.velocity += Vector3(0.0, -wall_slide_gravity, 0.0) * delta
		
	if parent.velocity.y > -20.2 || parent.velocity.y < -19.8:
		print("yep")
		parent.velocity.y = wall_slide_terminal_velocity	
	else:
		print("<, ", parent.velocity.y)
		parent.velocity.y = lerp(parent.velocity.y, wall_slide_terminal_velocity, wall_slide_gravity)
	
	if !parent.is_on_wall_only():
		parent.rotation = Vector3(0,0,0)
		return process_state_change(fall_state)
	return null
