extends CharacterBody2D

enum characterState{
	IDLE,
	WALKING,
	WORKING,
	SELECTED
}

const MAX_SPEED: float = 50
const SPEED_DIVIDER: float = 2

var current_state: characterState
var target_position: Vector2
var current_speed: float
var selected: bool = false:
	set(value):
		if value:
			current_speed = MAX_SPEED / SPEED_DIVIDER
			$SelectionOutline.show()
		else: 
			current_speed = MAX_SPEED
			$SelectionOutline.hide()
		selected = value

func check_select() -> void:
	if Input.is_action_just_pressed("click"):
		var mouse_position = get_global_mouse_position()
		if mouse_position.distance_to(global_position) < 25:
			selected = !selected
			return
		if selected:
			target_position = mouse_position
			current_state = characterState.WALKING
			selected = false
	
func state_machine() -> void:
	match current_state:
		characterState.IDLE:
			check_select()
		characterState.WALKING:
			check_select()
			var direction = (target_position - global_position).normalized()
			velocity = direction * current_speed
			if target_position.distance_to(global_position) < 1:
				velocity = Vector2.ZERO
				current_state = characterState.IDLE
		characterState.WORKING:
			pass

func _process(_delta: float) -> void:
	state_machine()
	move_and_slide()
