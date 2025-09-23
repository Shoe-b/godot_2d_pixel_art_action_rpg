extends CharacterBody2D

const SPEED = 100.0
var input_vector: = Vector2.ZERO
@onready var animation_tree: AnimationTree = $AnimationTree

# Player identification (1 for player 1, 2 for player 2)
@export var player_id: int = 1


func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	
	# Get input based on player ID
	if player_id == 1:
		input_vector = Input.get_vector("move_left","move_right", "move_up", "move_down")
	else:
		input_vector = Input.get_vector("p2_move_left","p2_move_right", "p2_move_up", "p2_move_down")
	
	if input_vector != Vector2.ZERO:
		var direction_vector: = Vector2(input_vector.x, -input_vector.y)
		update_blend_positions(direction_vector)
		 
	
	velocity = input_vector * SPEED
	move_and_slide()
	 
func update_blend_positions(direction_vector: Vector2) -> void:
	animation_tree.set("parameters/StateMachine/MoveState/RunState/blend_position",  direction_vector)
	animation_tree.set("parameters/StateMachine/MoveState/StandState/blend_position",  direction_vector)
