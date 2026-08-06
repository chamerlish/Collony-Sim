extends Camera2D

var is_dragging: bool

var zoom_speed = 0.1

var min_zoom: float = 0.5
var max_zoom: float = 2.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and is_dragging:
		global_position -= event.relative
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			is_dragging = event.is_pressed()

		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += Vector2.ONE * zoom_speed
			zoom = zoom.clamp(Vector2.ONE * min_zoom, Vector2.ONE * max_zoom)

		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= Vector2.ONE * zoom_speed
			zoom = zoom.clamp(Vector2.ONE * min_zoom, Vector2.ONE * max_zoom)
