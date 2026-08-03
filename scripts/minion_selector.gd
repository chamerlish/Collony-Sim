extends Control

var start_pos: Vector2
var end_pos: Vector2
var top_left: Vector2
var bottom_right: Vector2
var box_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_selection() -> void:
	var selectables = get_tree().get_nodes_in_group("selectables")
	for minion: Node2D in selectables:
		if (minion.global_position.x > top_left.x and minion.global_position.y > top_left.y) and (minion.global_position.x < bottom_right.x and minion.global_position.y < bottom_right.y):
			minion.selected = true
		else:
			minion.selected = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		start_pos = get_global_mouse_position()
	elif Input.is_action_pressed("click"):
		top_left = start_pos.min(end_pos)
		bottom_right = start_pos.max(end_pos)
		box_size = abs(end_pos - start_pos)
		end_pos = get_global_mouse_position()
		update_selection()
		queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(top_left, box_size), Color.WHITE, false)
