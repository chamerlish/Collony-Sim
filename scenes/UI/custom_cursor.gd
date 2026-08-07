extends CanvasLayer

const MOUSE_SPEED: float = 20.5

const PRESSED_MOD: float = 0.9

@onready var mouse_origin: Marker2D = $MouseOrigin


@onready var mouse_texture: Sprite2D = $MouseOrigin/MouseTexture

enum MouseState {
	IDLE,
	HOVER,
	DRAGGING,
	DISABLED
}

var current_state: MouseState:
	set(new_state):
		_update_sprite(new_state)
		current_state = new_state


func _update_sprite(new_state: MouseState):
	mouse_texture.frame = new_state

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _physics_process(delta: float) -> void:
	#global_position = lerp(global_position, get_global_mouse_position(), MOUSE_SPEED * delta)
	mouse_origin.global_position = mouse_origin.get_global_mouse_position()
	
	var desired_rotation: float = -12.5 if Input.is_action_pressed("click") else 0.0
	mouse_origin.rotation_degrees = lerp(mouse_origin.rotation_degrees, desired_rotation, MOUSE_SPEED * delta)
	
	var desired_scale: Vector2 = PRESSED_MOD * Vector2.ONE if Input.is_action_pressed("click") else Vector2.ONE
	scale = lerp(scale, desired_scale, MOUSE_SPEED * delta)
