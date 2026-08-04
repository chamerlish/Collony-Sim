extends CharacterBody2D

class_name Minion

enum characterState{
	IDLE,
	WALKING,
	WORKING,
}

const MAX_SPEED: float = 200
const SPEED_DIVIDER: float = 2
const STARTING_SPEED: float = 20

const DEFAULT_SPRITE_SIZE = Vector2.ONE

const SIZE_SUM = DEFAULT_SPRITE_SIZE.x + DEFAULT_SPRITE_SIZE.y
const BOUNCE_PARAM = 0.1

var current_state: characterState
var target_position: Vector2
var target_speed: float
var current_speed: float
var current_using_spot: FishingSpot

var selected: bool = false:
	set(value):
		if value:
			target_speed = MAX_SPEED / SPEED_DIVIDER
			selection_outline.show()
		else: 
			target_speed = MAX_SPEED
			selection_outline.hide()
		selected = value
		
@onready var sprite: Sprite2D = $SpriteBundle/Sprite2D
@onready var selection_outline: Sprite2D = $SpriteBundle/SelectionOutline
@onready var sprite_bundle: Node2D = $SpriteBundle

@onready var squish_sfx: AudioStreamPlayer2D = $SquishSFX

func _play_squish_sfx():
	squish_sfx.pitch_scale = randf_range(0.8, 1.2)
	squish_sfx.volume_db = randf_range(-1, 1)
	squish_sfx.play()

func _bounce():
	var x_scale = randf_range(BOUNCE_PARAM, SIZE_SUM - BOUNCE_PARAM)
	sprite_bundle.scale = Vector2(x_scale, SIZE_SUM - x_scale)
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

func free_fishing_spot() -> void:
	current_using_spot = null
	current_state = characterState.IDLE

func state_machine() -> void:
	match current_state:
		characterState.IDLE:
			check_select()
			current_speed = STARTING_SPEED
		characterState.WALKING:
			check_select()
			
			var direction = (target_position - global_position).normalized()
			
			if target_position.distance_to(global_position) < 100:
				velocity = velocity.lerp(Vector2.ZERO, 0.03)
				if velocity.length() < 1:
					velocity = Vector2.ZERO
					current_state = characterState.IDLE
			else:
				current_speed = lerp(current_speed, target_speed, 0.03)
				velocity = direction * current_speed
				sprite.flip_h = bool(clamp(velocity.x, 0, 1))
				selection_outline.flip_h = bool(clamp(velocity.x, 0, 1))
			for i in get_slide_collision_count():
				var current_colider = get_slide_collision(i).get_collider() as FishingSpot
				if current_colider and !current_colider.is_used:
					current_using_spot = current_colider
					current_using_spot.is_used = true
					current_using_spot.free_seal.connect(free_fishing_spot)
					current_using_spot._start_fishing()
					current_state = characterState.WORKING

			queue_redraw()
			
		characterState.WORKING:
			velocity = Vector2.ZERO
			
func _draw() -> void:
	if current_state != characterState.WALKING:
		return
	draw_line(Vector2.ZERO, to_local(target_position), Color.WHITE, 3.0)

func _process(delta: float) -> void:
	state_machine()
	move_and_slide()
	reset_sprite_size(delta)
	
func reset_sprite_size(delta: float):
	sprite_bundle.scale = sprite_bundle.scale.lerp(DEFAULT_SPRITE_SIZE, delta * 10)

func is_in_selection_box(top_left: Vector2, bottom_right: Vector2) -> bool:
	return (global_position.x > top_left.x and global_position.y > top_left.y) and (global_position.x < bottom_right.x and global_position.y < bottom_right.y)
