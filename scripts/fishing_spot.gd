class_name FishingSpot
extends StaticBody2D


signal free_seal
var is_used: bool
@export var fish_left: int = 10:
	set(value):
		if value <= 0:
			queue_free()
			free_seal.emit()
		else:
			fish_left = value
