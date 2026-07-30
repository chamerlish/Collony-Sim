extends CharacterBody2D

enum characterState{
	IDLE,
	WALKING,
	WORKING,
	SELECTED
}

var current_state: characterState
var target_position: Vector2

func state_machine() -> void:
	match current_state:
		characterState.IDLE:
			pass
		characterState.WALKING:
			pass
		characterState.WORKING:
			pass
		characterState.SELECTED:
			pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass #wow i can write comments :D
