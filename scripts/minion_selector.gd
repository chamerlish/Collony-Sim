extends Control

var start_pos: Vector2
var end_pos: Vector2
var top_left: Vector2
var bottom_right: Vector2
var box_size: Vector2


var is_selecting: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_selection() -> void:
	var selectables = get_tree().get_nodes_in_group("selectables")
	for minion: Minion in selectables:
		if minion.is_in_selection_box(top_left, bottom_right):
			minion.selected = true
		else:
			minion.selected = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		start_pos = get_global_mouse_position()
		end_pos = start_pos
		is_selecting = true

	elif Input.is_action_pressed("click"):
		end_pos = get_global_mouse_position()
		
		top_left = Vector2(
			min(start_pos.x, end_pos.x),
			min(start_pos.y, end_pos.y)
		)
		bottom_right = Vector2(
			max(end_pos.x, start_pos.x), 
			max(end_pos.y, start_pos.y)
		)
		
		box_size = abs(end_pos - start_pos)
		is_selecting = true
		update_selection()

	else:
		is_selecting = false
	
	queue_redraw()

func _draw() -> void:
	if !is_selecting:
		return
		
	draw_rect(Rect2(top_left, box_size), Color(0.0, 0.0, 0.0, 0.19), true)
	draw_rect(Rect2(top_left, box_size), Color(Color.WHITE, 0.9), false, 2.0)
