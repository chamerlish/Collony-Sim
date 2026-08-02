extends CharacterBody2D

enum characterState{
	IDLE,
	WALKING,
	WORKING,
}

const MAX_SPEED: float = 100
const SPEED_DIVIDER: float = 2

const DEFAULT_SPRITE_SIZE = Vector2(0.6, 0.6)

const SIZE_SUM = DEFAULT_SPRITE_SIZE.x + DEFAULT_SPRITE_SIZE.y
const BOUNCE_PARAM = 0.1

var current_state: characterState
var target_position: Vector2
var current_speed: float
var selected: bool = false:
	set(value):
		if value:
			current_speed = MAX_SPEED / SPEED_DIVIDER
			selection_outline.show()
		else: 
			current_speed = MAX_SPEED
			selection_outline.hide()
		selected = value
		
@onready var sprite: Sprite2D = $Sprite2D
@onready var selection_outline: Sprite2D = $SelectionOutline
@onready var squish_sfx: AudioStreamPlayer2D = $SquishSFX

func _play_squish_sfx():
	squish_sfx.pitch_scale = randf_range(0.8, 1.2)
	squish_sfx.volume_db = randf_range(-1, 1)
	squish_sfx.play()

func _bounce():
	var x_scale = randf_range(BOUNCE_PARAM, SIZE_SUM - BOUNCE_PARAM)
	sprite.scale = Vector2(x_scale, 1.2 - x_scale)
	selection_outline.scale = Vector2(x_scale, 1.2 - x_scale)
	_play_squish_sfx()
	
func check_select() -> void:
	if Input.is_action_just_pressed("click"):
		var mouse_position = get_global_mouse_position()
		if mouse_position.distance_to(global_position) < 25:
			selected = !selected
			_bounce()
			return
		if selected:
			target_position = mouse_position
			current_state = characterState.WALKING
			selected = false
			_bounce()
	
func state_machine() -> void:
	match current_state:
		characterState.IDLE:
			check_select()
		characterState.WALKING:
			check_select()
			var direction = (target_position - global_position).normalized()
			velocity = direction * current_speed
			queue_redraw()
			if target_position.distance_to(global_position) < 1:
				velocity = Vector2.ZERO
				current_state = characterState.IDLE
		characterState.WORKING:
			pass
			
func _draw() -> void:
	if current_state != characterState.WALKING:
		return
	draw_line(Vector2.ZERO, to_local(target_position), Color.WHITE, 3.0)

func _process(delta: float) -> void:
	state_machine()
	move_and_slide()
	reset_sprite_size(delta)
	
func reset_sprite_size(delta: float):
	sprite.scale = sprite.scale.lerp(DEFAULT_SPRITE_SIZE, delta * 10)
	selection_outline.scale = sprite.scale.lerp(DEFAULT_SPRITE_SIZE, delta * 10)
	
