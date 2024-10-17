class_name Player
extends CharacterBody3D

#@onready
#var animation_player = $Visuals/TempCharacter/AnimationPlayer
#@onready 
#var animation_tree: AnimationTree = $Visuals/TempCharacter/AnimationTree
@onready
var player_state_machine = $PlayerStateMachine
#var animation_player_state_machine

func _ready() -> void:
#	animation_player_state_machine = animation_tree["parameters/playback"]
	player_state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	player_state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	player_state_machine.process_physics(delta)

func _process(delta: float) -> void:
	player_state_machine.process_frame(delta)
