extends CharacterBody2D

enum characterState{
	IDLE,
	WALKING,
	WORKING,
	SELECTED
}

const MAX_SPEED = 50
const SPEED_DIVIDER = 2

var current_state: characterState
var target_position: Vector2
var current_speed: int
var selected: bool

func check_select() -> void:
	if Input.is_action_just_pressed("click"):
		if get_global_mouse_position().distance_to(global_position) < 15:
			selected = true
			current_speed = MAX_SPEED / SPEED_DIVIDER
func state_machine() -> void:
	match current_state:
		characterState.IDLE:
			check_select()
		characterState.WALKING:
			current_speed = MAX_SPEED
			check_select()
			var direction = (target_position - global_position).normalized()
			velocity = direction * current_speed
			if target_position.distance_to(global_position) < 1:
				velocity = Vector2.ZERO
				current_state = characterState.IDLE
		characterState.WORKING:
			pass
		characterState.SELECTED:
			if Input.is_action_just_pressed("click"):
				target_position = get_global_mouse_position()
				current_state = characterState.WALKING
			elif target_position.distance_to(global_position) < 1:
				velocity = Vector2.ZERO
				current_state = characterState.IDLE

func state_machine2() -> void:
	match current_state:
		characterState.IDLE:
			check_select()
			if selected == true and Input.is_action_just_pressed("click"):
				print("set to walking")
				target_position = get_global_mouse_position()
				current_state = characterState.WALKING
		characterState.WALKING:
			current_speed = MAX_SPEED
			check_select()
			var direction = (target_position - global_position).normalized()
			velocity = direction * current_speed
			if target_position.distance_to(global_position) < 1:
				velocity = Vector2.ZERO
				current_state = characterState.IDLE
				selected = false
		characterState.WORKING:
			pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	state_machine2()
	print(current_state, selected)
	move_and_slide()
