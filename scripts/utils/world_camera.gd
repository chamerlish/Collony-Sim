extends Camera2D

var is_dragging: bool

var zoom_speed = 0.1

var min_zoom: float = 0.5
var max_zoom: float = 2.0

var pre_drag_state: Cursor.MouseState

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and is_dragging:
		global_position -= event.relative
	
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				if event.is_pressed():
					pre_drag_state = Cursor.current_state
					Cursor.current_state = Cursor.MouseState.DRAGGING
					is_dragging = true
				else: 
					Cursor.current_state = pre_drag_state
					is_dragging = false

			MOUSE_BUTTON_WHEEL_UP:
				zoom += Vector2.ONE * zoom_speed
				zoom = zoom.clamp(Vector2.ONE * min_zoom, Vector2.ONE * max_zoom)

			MOUSE_BUTTON_WHEEL_DOWN:
				zoom -= Vector2.ONE * zoom_speed
				zoom = zoom.clamp(Vector2.ONE * min_zoom, Vector2.ONE * max_zoom)

		if zoom.distance_to(Vector2.ONE * min_zoom) < 0.01:
				AudioServer.set_bus_effect_enabled(0, 0, true)
		else: 
			AudioServer.set_bus_effect_enabled(0, 0, false)
